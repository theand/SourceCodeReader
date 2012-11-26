//
//  ViewController.m
//  SourceCodeReader
//
//  Created by sdt5 on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "DZDocumentsPickerController.h"
#import <zipzap/zipzap.h>

@interface ViewController () <SourcePickerDelegate, DZDocumentsPickerControllerDelegate>

@end


@implementation ViewController {
}

@synthesize myWebView;

@synthesize sourcePickerPopover;

@synthesize sourcePickerController;

@synthesize docPickerController;

@synthesize docPickerPopOverController;



#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self clearAllCache];

//    [self testZipRead];
//    [self testExtract];
}


- (void)testZipRead {
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CoreDataUtility.zip"];

    ZZArchive *oldArchive = [ZZArchive archiveWithContentsOfURL:[NSURL fileURLWithPath:path]];
    ZZArchiveEntry *firstArchiveEntry = oldArchive.entries[2];
    DebugLog(@"filename : %@", firstArchiveEntry.fileName);
    DebugLog(@"The first entry's uncompressed size is %d bytes.", firstArchiveEntry.uncompressedSize);
    DebugLog(@"The first entry's data is: %@.", firstArchiveEntry.data);


}

- (void)testExtract {

    NSString *pathForDocument = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *fm = [NSFileManager defaultManager];

    NSString *path = [pathForDocument stringByAppendingPathComponent:@"import/highlight.zip"];
    ZZArchive *oldArchive = [ZZArchive archiveWithContentsOfURL:[NSURL fileURLWithPath:path]];


    for (ZZArchiveEntry *entry in oldArchive.entries) {
        NSString *fileType = nil;
        NSError *theError = nil;
        if (entry.fileMode & S_IFDIR) {
            fileType = @"DIR";
            if (![fm createDirectoryAtPath:[pathForDocument stringByAppendingPathComponent:entry.fileName] withIntermediateDirectories:YES attributes:nil error:&theError]) {
                DebugLog(@"ERROR!! in createDirectory : %@", theError.localizedDescription);
            }
        } else if (entry.fileMode & S_IFREG) {
            fileType = @"REGULAR";
            [self checkForIntermediatePath:[pathForDocument stringByAppendingPathComponent:entry.fileName]];
            if (![fm createFileAtPath:[pathForDocument stringByAppendingPathComponent:entry.fileName] contents:entry.data attributes:nil]) {
                DebugLog(@"ERROR!! in createFile - %@", [pathForDocument stringByAppendingPathComponent:entry.fileName] );
            }
        } else if ( entry.fileMode &  S_IFMT){
            fileType = @"S_IFMT";

        } else if ( entry.fileMode & S_IFIFO){
            fileType = @"S_IFIFO";

        } else if ( entry.fileMode & S_IFCHR){
            fileType = @"S_IFCHR";

        } else if ( entry.fileMode & S_IFBLK){
            fileType = @"S_IFBLK";

        } else if ( entry.fileMode & S_IFLNK){
            fileType = @"S_IFLNK";

        } else if ( entry.fileMode & S_IFSOCK){
            fileType = @"S_IFSOCK";

        }else{
            fileType = @"What Is It!";
        }
        DebugLog(@"filename : %@ - %d bytes - %x - %@", entry.fileName, entry.uncompressedSize, entry.fileMode, fileType);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark methods for source file view

- (IBAction)viewSourceList:(id)sender {
    if (self.sourcePickerController == nil) {
        self.sourcePickerController = [[SourcePickerController alloc] initWithStyle:UITableViewStylePlain];
        self.sourcePickerController.delegate = self;
        self.sourcePickerPopover = [[UIPopoverController alloc] initWithContentViewController:self.sourcePickerController];
    }
    [self.sourcePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (IBAction)goDropbox:(id)sender {
    if (docPickerController == nil) {
        docPickerController = [[DZDocumentsPickerController alloc] init];
        docPickerController.includePhotoLibrary = NO;
        docPickerController.documentType = DocumentTypeZip;
        docPickerController.allowEditing = NO;
        docPickerController.delegate = self;
        docPickerController.availableServices = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:ServiceTypeDropbox], nil];

        [docPickerController setContentSizeForViewInPopover:CGSizeMake(400, 600)];
        docPickerController.deviceType = DeviceTypeiPad;
        docPickerPopOverController = [[UIPopoverController alloc] initWithContentViewController:docPickerController];
    }

    [docPickerPopOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}


#pragma mark - UIDocumentsPickerControllerDelegate Methods

- (void)documentPickerController:(DZDocumentsPickerController *)picker didFinishPickingFileWithInfo:(NSDictionary *)info {
    if (info) {
        if (picker.documentType == DocumentTypeZip ||
                picker.documentType == DocumentTypeAll) {
            NSData *data = [info objectForKey:@"file"];
            NSString *extension = [info objectForKey:@"extension"];
            NSString *name = [info objectForKey:@"name"];

            NSString *zipPath = [self saveToImportDirectory:data extension:extension name:name];
            [self extractToProject:zipPath];

            //TODO done notice - HUD progress?
        }
    }

    [docPickerPopOverController dismissPopoverAnimated:YES];
}

- (void)extractToProject:(NSString *)zipPath {
    ZZArchive *zipArchive = [ZZArchive archiveWithContentsOfURL:[NSURL fileURLWithPath:zipPath]];

    NSString *pathForProject = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Project"];
    NSFileManager *fm = [NSFileManager defaultManager];

    for (ZZArchiveEntry *entry in zipArchive.entries) {
        NSString *fileType = nil;
        NSError *theError = nil;
        NSString *entryPath = [pathForProject stringByAppendingPathComponent:entry.fileName];

        if (entry.fileMode & S_IFDIR) {
            fileType = @"DIR";
            if (![fm createDirectoryAtPath:entryPath withIntermediateDirectories:YES attributes:nil error:&theError]) {
                DebugLog(@"ERROR!! in createDirectory : %@", theError.localizedDescription);
            }
        } else if (entry.fileMode & S_IFREG) {
            fileType = @"REGULAR";
            [self checkForIntermediatePath:entryPath];
            if (![fm createFileAtPath:entryPath contents:entry.data attributes:nil]) {

                DebugLog(@"ERROR!! in createFile - %@", entryPath );
            }
        } else if ( entry.fileMode &  S_IFMT){
            fileType = @"S_IFMT";

        } else if ( entry.fileMode & S_IFIFO){
            fileType = @"S_IFIFO";

        } else if ( entry.fileMode & S_IFCHR){
            fileType = @"S_IFCHR";

        } else if ( entry.fileMode & S_IFBLK){
            fileType = @"S_IFBLK";

        } else if ( entry.fileMode & S_IFLNK){
            fileType = @"S_IFLNK";

        } else if ( entry.fileMode & S_IFSOCK){
            fileType = @"S_IFSOCK";

        }else{
            fileType = @"What Is It!";
        }
        DebugLog(@"filename : %@ - %d bytes - %s - %@", entry.fileName, entry.uncompressedSize, [self intToBinary:entry.fileMode], fileType);
    }
}

- (char *)intToBinary:(int) i {
    static char s[32 + 1] = { '0', };
    int count = 32;

    do { s[--count] = '0' + (char) (i & 1);
        i = i >> 1;
    } while (count);

    return s;
}

- (NSString *)saveToImportDirectory:(NSData *)data extension:(NSString *)extension name:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    NSString *fileName = [NSString stringWithFormat:@"import/%@.%@", name, extension];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    DebugLog(@"filePath saving: %@", filePath);
    [data writeToFile:filePath atomically:YES];
    return filePath;
}


- (void)checkForIntermediatePath:(NSString *)path {
    NSMutableArray *components = [NSMutableArray arrayWithArray:[path pathComponents]];
    if ([components count] <2){
        return;
    }
    [components removeLastObject];
    NSString *containingDirectory = [NSString pathWithComponents:components];
    DebugLog(@"containgFolder: %@", containingDirectory);
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDirExists = [fm fileExistsAtPath:containingDirectory];
    DebugLog(@"isDirExists : %d", isDirExists);
    if( !isDirExists){
        NSError *theError = nil;
        if (![fm createDirectoryAtPath:containingDirectory withIntermediateDirectories:YES attributes:nil error:&theError]) {
            DebugLog(@"ERROR!! in createDirectory : %@", theError.localizedDescription);
        }

    }
}


- (void)dismissPickerController:(DZDocumentsPickerController *)picker {
    DebugLog(@"");

    [docPickerPopOverController dismissPopoverAnimated:YES];
}



#pragma mark sourceListPickerDelegate

- (void)sourceSelected:(NSString *)source {
    [self loadSourceFilePath:[self getSourcerBundlePath]
                    filePath:[NSString stringWithFormat:@"sample_output/%@.html", source]];

    [self.sourcePickerPopover dismissPopoverAnimated:YES];
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


@end
