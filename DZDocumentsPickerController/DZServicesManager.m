
//
//  DZServicesManager.h
//  DZDocumentsPickerController
//
//  Created Ignacio Romero Zurbuchen on 5/4/12.
//  Copyright (c) 2011 DZen Interaktiv.
//  Licence: MIT-Licence
//

#import "DZServicesManager.h"

NSString *const ServicesTypeArr[1] = {@"Dropbox"};

@implementation DZServicesManager
@synthesize delegate, downloadingFileInfo, currentService, allowedDocuments;
@synthesize dropboxClient;
@synthesize parentViewController;

- (id)initWithDelegate:(id)applicationDelegate
{
    self = [super init];
    if (self)
    {
        alrtCenter = [[DZAlertCenter alloc] init];
        appDelegate = applicationDelegate;

        if (self.currentService == ServiceTypeDropbox)
        {

        }
    }

    return self;
}

- (void)prepareForLogin
{
    NSLog(@"%s",__FUNCTION__);

    if (self.currentService == ServiceTypeDropbox)
    {
        if (![[DBSession sharedSession] isLinked]) [[DBSession sharedSession] link];
        else [self loadFilesAtPath:@"/"];
    }
}

- (void)loginWithInfo:(NSDictionary *)userInfo
{
    NSLog(@"%s",__FUNCTION__);

    if (userInfo)
    {
    }
    else
    {
        [alrtCenter noActionAlertWithTitle:@"Login Error" withMessage:@"An error has occurred. Please try again later." withCancelButton:@"OK"];
    }
}

- (void)cancelLogin
{
    NSLog(@"%s",__FUNCTION__);

    if (delegate && [delegate respondsToSelector:@selector(servicesManagerDidCancelLogin:)])
        [delegate servicesManagerDidCancelLogin:self];
}

- (void)logOut
{
    if (self.currentService == ServiceTypeDropbox)
    {
        [[DBSession sharedSession] unlinkAll];
    }
    if (delegate && [delegate respondsToSelector:@selector(servicesManagerDidLogOut:)])
        [delegate servicesManagerDidLogOut:self];
}


- (void)loadFilesAtPath:(NSString *)filepath
{
    if (self.currentService == ServiceTypeDropbox)
    {
        [[self dropboxClient] loadMetadata:filepath];
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)reloadAtPath:(NSString *)path
{
    NSLog(@"%s",__FUNCTION__);

    if (self.currentService == ServiceTypeDropbox)
    {
        NSLog(@"path : %@",path);
        [[self dropboxClient] loadMetadata:path];
    }
}

- (void)downloadFileAtPath:(NSString *)webpath intoLocalPath:(NSString *)localpath
{
    if (self.currentService == ServiceTypeDropbox)
    {
        [[self dropboxClient] loadFile:webpath intoPath:localpath];
    }

    [alrtCenter loadingAlertWithTitle:[NSString stringWithFormat:@"Downloading from %@",[DZServicesManager serviceTypeToString:self.currentService]]
                              message:@"Please wait until the download has completely finished\n\n"
                    cancelButtonTitle:@"Cancel"
                           withTarget:self
                      andSingleAction:@"cancelDownloading"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)cancelDownloading
{
    NSLog(@"%s",__FUNCTION__);

    if (self.currentService == ServiceTypeDropbox)
    {
        NSString *webPath = [downloadingFileInfo objectForKey:@"webPath"];
        NSString *localPath = [downloadingFileInfo objectForKey:@"localPath"];

        [[self dropboxClient] cancelFileLoad:webPath];
        [[self dropboxClient] cancelAllRequests];

        //delete file if totally downloaded
        if ([[NSFileManager defaultManager] fileExistsAtPath:localPath])
            [[NSFileManager defaultManager] removeItemAtPath:localPath error:nil];
        else NSLog(@"Couldn't erase file at path : %@",localPath);
    }

    [alrtCenter closeAlertView];
    downloadingFileInfo = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Dropbox SDK Methods

- (DBRestClient *)dropboxClient
{
    if (dropboxClient == nil)
    {
        dropboxClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        [dropboxClient setDelegate:self];
    }
    return dropboxClient;
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    //NSLog(@"%s",__FUNCTION__);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    if (metadata.isDirectory)
    {
        NSArray *dbFullFilesList = [[NSArray alloc] initWithArray:metadata.contents];
        NSMutableArray *dbFilesList = [[NSMutableArray alloc] init];

        for (int i = 0; i < [dbFullFilesList count]; i++)
        {
            DBMetadata *fileMetaData = [dbFullFilesList objectAtIndex:i];
            NSString *extension = [fileMetaData.filename pathExtension];

            DZDocument *document = [[DZDocument alloc] init];
            document.name = fileMetaData.filename;
            document.path = fileMetaData.path;
            document.size = fileMetaData.humanReadableSize;
            document.isDirectory = fileMetaData.isDirectory;

            if ((fileMetaData.isDirectory && [extension isEqualToString:@""]) ||
                ([DZDocument getDocumentsTypeOfFile:fileMetaData.filename] == allowedDocuments
                 || allowedDocuments == DocumentTypeAll)) [dbFilesList addObject:document];
        }

        if (delegate && [delegate respondsToSelector:@selector(servicesManager:didLoadFiles:)])
            [delegate servicesManager:self didLoadFiles:dbFilesList];
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)restClient:(DBRestClient *)client metadataUnchangedAtPath:(NSString*)path
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    NSLog(@"Meta Data load failed with error : %@", error);
}


//Downloading File
- (void)restClient:(DBRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath
{
    [alrtCenter.uploadProgressView setProgress:progress animated:YES];
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
{
    NSLog(@"%s",__FUNCTION__);

    NSString *fileName = [localPath.pathComponents lastObject];
    NSString *extension = [localPath pathExtension];
    NSString *name = [fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",extension] withString:@""];

    id pickedFile = (NSData *)[NSData dataWithContentsOfFile:localPath];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:pickedFile,@"file",extension,@"extension",name,@"name", nil];

    if ([delegate respondsToSelector:@selector(servicesManager:didDownloadFile:)])
        [delegate servicesManager:self didDownloadFile:dic];

    //delete file if totally downloaded
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath])
        [[NSFileManager defaultManager] removeItemAtPath:localPath error:nil];
    else NSLog(@"Couldn't erase file at path : %@",localPath);

    [alrtCenter closeAlertView];
    downloadingFileInfo = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError*)error
{
    NSLog(@"%s",__FUNCTION__);

    [alrtCenter closeAlertView];
    NSString *cachePath = [downloadingFileInfo objectForKey:@"cachePath"];

    [alrtCenter noActionAlertWithTitle:@"Download Error"
                           withMessage:@"The file could not be downloaded at this time. Please try again later."
                      withCancelButton:@"OK"];

    //delete file if totally downloaded
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath])
        [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    else NSLog(@"Couldn't erase file at path : %@",cachePath);

    downloadingFileInfo = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - NSURLConnectionDelegate Methods
// Used to manage CloudApp downloads and loading progress

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s",__FUNCTION__);
    dataTotalSize = response.expectedContentLength;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!loadingData) loadingData = [[NSMutableData alloc] initWithData:data];
    else [loadingData appendData:data];

    float progress = ((float)loadingData.length/(float)dataTotalSize);

    [alrtCenter.uploadProgressView setProgress:progress animated:YES];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s",__FUNCTION__);
    NSString *fileName = [self.downloadingFileInfo objectForKey:@"filename"];
    NSString *extension = [fileName pathExtension];
    NSString *name = [fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",extension] withString:@""];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:loadingData,@"file",extension,@"extension",name,@"name", nil];

    if ([delegate respondsToSelector:@selector(servicesManager:didDownloadFile:)])
        [delegate servicesManager:self didDownloadFile:dic];

    [alrtCenter closeAlertView];
    downloadingFileInfo = nil;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - Helper Methods

+ (NSString *)serviceTypeToString:(ServiceType)type
{
    return ServicesTypeArr[type];
}

+ (NSArray *)servicesSupported
{
    int count = sizeof(ServicesTypeArr)/sizeof(ServicesTypeArr[0]);
	NSArray *servicesSupportedArr = [[NSArray alloc] initWithObjects:ServicesTypeArr count:count];

    return servicesSupportedArr;
}

- (id)getSettingsForObjectForKey:(NSString *)objKey
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Cloud-Settings" ofType:@"plist"];
    NSDictionary *loadedPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    return [loadedPlist objectForKey:objKey];
}

@end
