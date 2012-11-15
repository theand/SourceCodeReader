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


@end
