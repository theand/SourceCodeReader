//
//  ViewController.m
//  SourceCodeReader
//
//  Created by sdt5 on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <DropboxSDK/DropboxSDK.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "DropboxSDK/DropboxSDK.h"

@interface ViewController ()<DBRestClientDelegate>

@end


@implementation ViewController
@synthesize myWebView;

#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self clearAllCache];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark methods for source file view
- (IBAction)showSourceFile:(id)sender {
    UIBarButtonItem *i = (UIBarButtonItem *) sender;
    NSString *bundlePath = [self getSourcerBundlePath];
    [self loadSourceFilePath:bundlePath filePath:[NSString stringWithFormat:@"sample_output/%@.html", i.title]];
}



- (NSString *)getSourcerBundlePath {
    NSString *bundlePath = [
            [[NSBundle mainBundle] bundlePath]
            stringByAppendingPathComponent:@"sourcer.bundle"];
    DebugLog(@"bundlePath : %@", bundlePath);
    return bundlePath;
}


- (void)loadSourceFilePath:(NSString *)rootPath filePath:(NSString *)sourcePath {
    NSString *filePath = [rootPath stringByAppendingPathComponent:sourcePath];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    [myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    DebugLog(@"filePath: %@", filePath);
    DebugLog(@"fileExists: %@", fileExists ? @"YES" : @"NO");
    DebugLog(@"url: %@", url);

}


- (void)clearAllCache {
    DebugLog(@"");
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

#pragma mark IBAction for Dropbox
- (IBAction)dropboxLink:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        DebugLog(@"Linking");
        [[DBSession sharedSession] linkFromController:self];
    }else{
        DebugLog(@"Unlinking");
        [[DBSession sharedSession] unlinkAll];
        [[[UIAlertView alloc]
                initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"
                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
                show];
    }
}

- (IBAction)uploadToDropbox:(id)sender {
    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSString *filename = @"Info.plist";
    NSString *destDir = @"/";
    [[self restClient] uploadFile:filename toPath:destDir
                    withParentRev:nil fromPath:localPath];
}

- (IBAction)listDropbox:(id)sender {
    [[self restClient] loadMetadata:@"/"];
}

- (IBAction)downloadFileFromDropbox:(id)sender {
    NSString *dropboxPath = @"/Info.plist";

    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
            (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localPath = [NSString stringWithFormat:@"%@%@",
                               documentsDirectory, dropboxPath];

    [[self restClient] loadFile:dropboxPath intoPath:localPath];
}


#pragma mark DBRestClientDelegate
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {

    DebugLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    DebugLog(@"File upload failed with error - %@", error);
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        DebugLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            DebugLog(@"\t%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    DebugLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    DebugLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    DebugLog(@"There was an error loading the file - %@", error);
}


#pragma mark common method for Dropbox
- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
                [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

@end
