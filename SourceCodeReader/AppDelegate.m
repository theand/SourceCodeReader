//
//  AppDelegate.m
//  SourceCodeReader
//
//  Created by sdt5 on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ZipHandler.h"

@interface AppDelegate () <DBSessionDelegate>

@end

@implementation AppDelegate

@synthesize dbSession, relinkUserId;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self startDropboxSession];
    [self checkImportDir];
    [self checkProjectDir];

    return YES;
}

#pragma mark - Documents/import Directory check
- (void)checkImportDir {
    NSString *importDirectory = [[ZipHandler getDocumentsPath] stringByAppendingPathComponent:@"import"];
    [ZipHandler ensureTargetDirectory:importDirectory];
}

- (void)checkProjectDir {
    NSString *projectDirectory = [[ZipHandler getDocumentsPath] stringByAppendingPathComponent:@"Project"];
    [ZipHandler ensureTargetDirectory:projectDirectory];
}



#pragma - mark Dropbox
- (void)startDropboxSession {
    NSString *appKey = @"xw31basq9ljaouo";
    NSString *appSecret = @"nhg0iaky979ugfb";
    NSString *root = kDBRootDropbox;

    dbSession = nil;
    dbSession = [[DBSession alloc]
            initWithAppKey:appKey appSecret:appSecret root:root];
    dbSession.delegate = self;
    [DBSession setSharedSession:dbSession];
}


- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId {
    relinkUserId = userId;
    [[[UIAlertView alloc] initWithTitle:@"Dropbox Error" message:@"An error was produced. Please try in a little while." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma - mark life cycle


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            DebugLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

@end
