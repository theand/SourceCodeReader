//
// Created by sdt5 on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import <zipzap/zipzap.h>


@interface ZipHandler : NSObject


+ (NSString *)getDocumentsPath;

+ (BOOL)fileExistsAtAbsolutePath:(NSString *)filename;
+ (BOOL)directoryExistsAtAbsolutePath:(NSString *)filename;

+ (void)ensureTargetDirectory:(NSString *)target;
+ (void)ensureIntermediatePathOfFile:(NSString *)path;


+ (NSString *)saveToImportDirectory:(NSData *)data extension:(NSString *)extension name:(NSString *)name;
+ (void)extractToProjectFromZip:(NSString *)zipPath;
+ (BOOL)saveRegularFileToProject:(ZZArchiveEntry *)entry entryPath:(NSString *)entryPath;


@end
