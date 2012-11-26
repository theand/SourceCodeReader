//
//  AppDelegate.m
//  SourceCodeReader
//
//  Created by sdt5 on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

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
    NSString *documentsDirectory = [self getDocumentsPath];
    NSString *importDirectory = [documentsDirectory stringByAppendingPathComponent:@"import"];

    BOOL dirExists = [self directoryExistsAtAbsolutePath:importDirectory];
    if ( dirExists){
        DebugLog(@"importDir already exists");
    }else{
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createDirectoryAtPath:importDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        DebugLog(@"importDir created!");
    }
}

- (void)checkProjectDir {
    NSString *documentsDirectory = [self getDocumentsPath];
    NSString *projectDirectory = [documentsDirectory stringByAppendingPathComponent:@"Project"];

    BOOL dirExists = [self directoryExistsAtAbsolutePath:projectDirectory];
    if ( dirExists){
        DebugLog(@"projectDir already exists");
    }else{
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createDirectoryAtPath:projectDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        DebugLog(@"projectDir created!");
    }
}


- (NSString *)getDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

-(BOOL)fileExistsAtAbsolutePath:(NSString*)filename {
    BOOL isDirectory;
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory];

    return fileExistsAtPath && !isDirectory;
}

-(BOOL)directoryExistsAtAbsolutePath:(NSString*)filename {
    BOOL isDirectory;
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory];

    return fileExistsAtPath && isDirectory;
}


#pragma - mark Dropbox
- (void)startDropboxSession {
    NSString *appKey = @"d42rw8ccbrt8cxh";
    NSString *appSecret = @"h4na6nerl3r85o1";
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
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

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
