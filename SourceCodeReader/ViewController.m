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
#import "ZipHandler.h"
#import "KOTreeViewController.h"
#import <zipzap/zipzap.h>

@interface ViewController () <SourcePickerDelegate, DZDocumentsPickerControllerDelegate>

@end


@implementation ViewController {
}

@synthesize myWebView;

@synthesize sourcePickerController;
@synthesize sourcePickerPopOverController;

@synthesize dropboxPickerController;
@synthesize dropboxPickerPopOverController;

@synthesize projectPickerController;
@synthesize projectPickerPopOverController;



#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self clearAllCache];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    sourcePickerPopOverController = nil;
    sourcePickerController = nil;

    dropboxPickerController = nil;
    dropboxPickerPopOverController = nil;

    projectPickerController = nil;
    projectPickerPopOverController = nil;

}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark methods for source file view

- (IBAction)viewSourceList:(id)sender {
    if (sourcePickerController == nil) {
        sourcePickerController = [[SourcePickerController alloc] initWithStyle:UITableViewStylePlain];
        sourcePickerController.delegate = self;
        sourcePickerPopOverController = [[UIPopoverController alloc] initWithContentViewController:sourcePickerController];
    }
    [sourcePickerPopOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (IBAction)goDropbox:(id)sender {
    if (dropboxPickerController == nil) {
        dropboxPickerController = [[DZDocumentsPickerController alloc] init];
        dropboxPickerController.includePhotoLibrary = NO;
        dropboxPickerController.documentType = DocumentTypeZip;
        dropboxPickerController.allowEditing = NO;
        dropboxPickerController.delegate = self;
        dropboxPickerController.availableServices = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:ServiceTypeDropbox], nil];

        [dropboxPickerController setContentSizeForViewInPopover:CGSizeMake(600, 700)];
        dropboxPickerController.deviceType = DeviceTypeiPad;
        dropboxPickerPopOverController = [[UIPopoverController alloc] initWithContentViewController:dropboxPickerController];
    }

    [dropboxPickerPopOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (IBAction)viewProjectDirectory:(id)sender {
    if (projectPickerController == nil) {
        projectPickerController = [[KOTreeViewController alloc] init];
        [projectPickerController setContentSizeForViewInPopover:CGSizeMake(700, 700)];
        projectPickerPopOverController = [[UIPopoverController alloc] initWithContentViewController:projectPickerController];
    }
    [projectPickerPopOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


#pragma mark - DZDocumentsPickerControllerDelegate Methods

- (void)documentPickerController:(DZDocumentsPickerController *)picker didFinishPickingFileWithInfo:(NSDictionary *)info {
    if (info) {
        if (picker.documentType == DocumentTypeZip ||
                picker.documentType == DocumentTypeAll) {
            NSData *data = [info objectForKey:@"file"];
            NSString *extension = [info objectForKey:@"extension"];
            NSString *name = [info objectForKey:@"name"];

            NSString *zipPath = [ZipHandler saveToImportDirectory:data extension:extension name:name];
            [ZipHandler extractToProjectFromZip:zipPath];

            //TODO done notice - HUD progress?
        }
    }

    [dropboxPickerPopOverController dismissPopoverAnimated:YES];
}


- (void)dismissPickerController:(DZDocumentsPickerController *)picker {
    DebugLog(@"");

    [dropboxPickerPopOverController dismissPopoverAnimated:YES];
}



#pragma mark sourceListPickerDelegate

- (void)sourceSelected:(NSString *)source {
    [self loadSourceFilePath:[self getSourcerBundlePath]
                    filePath:[NSString stringWithFormat:@"sample_output/%@.html", source]];

    [sourcePickerPopOverController dismissPopoverAnimated:YES];
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
