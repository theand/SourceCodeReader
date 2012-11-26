//
//  NSObject+Theand.m
//  SourceCodeReader
//
//  Created by sdt5 on 11/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Theand.h"

@implementation NSObject (Theand)


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

- (void)ensureTargetDirectory:(NSString *)target {
    NSError *theError = nil;
    BOOL dirExists = [self directoryExistsAtAbsolutePath:target];
    if ( dirExists){
        DebugLog(@"%@ already exists", target);
    }else{
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm createDirectoryAtPath:target withIntermediateDirectories:YES attributes:nil error:&theError]){
            DebugLog(@"ERROR!! in createDirectory : %@", theError.localizedDescription);
        }else{
            DebugLog(@"%@ created!", target);
        }
    }
}


- (void)ensureIntermediatePathOfFile:(NSString *)path {
    NSMutableArray *components = [NSMutableArray arrayWithArray:[path pathComponents]];
    if ([components count] <2){
        DebugLog(@"no intermediate path for %@", path);
        return;
    }

    DebugLog(@"getting containing folder for %@", path);
    [components removeLastObject];
    NSString *containingDirectory = [NSString pathWithComponents:components];
    DebugLog(@"containgFolder: %@", containingDirectory);

    [self ensureTargetDirectory:containingDirectory];
}


@end
