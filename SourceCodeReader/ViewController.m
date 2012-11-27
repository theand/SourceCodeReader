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



#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self clearAllCache];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    sourcePickerPopover = nil;
    sourcePickerController = nil;

    docPickerController = nil;
    docPickerPopOverController = nil;
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

            NSString *zipPath = [ZipHandler saveToImportDirectory:data extension:extension name:name];
            [ZipHandler extractToProjectFromZip:zipPath];

            //TODO done notice - HUD progress?
        }
    }

    [docPickerPopOverController dismissPopoverAnimated:YES];
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
