//
//  NSObject+Theand.h
//  SourceCodeReader
//
//  Created by sdt5 on 11/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface NSObject (Theand)

- (NSString *)getDocumentsPath;

- (BOOL)fileExistsAtAbsolutePath:(NSString *)filename;
- (BOOL)directoryExistsAtAbsolutePath:(NSString *)filename;

- (void)ensureTargetDirectory:(NSString *)target;
- (void)ensureIntermediatePathOfFile:(NSString *)path;

@end
