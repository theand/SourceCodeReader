
//  Created by Ignacio Romero Zurbuchen on 10/28/11.
//  Copyright (c) 2011 DZen Interaktiv. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface NSString (DZEN) 
{
    
}

+ (NSString *)cleanWhiteSpacesFrom:(NSString *)string;
+ (NSString *)replaceWhiteSpacesFrom:(NSString *)string with:(NSString *)symbol;

+ (NSString *)getBundlePathForFile:(NSString *)fileName;
+ (NSString *)getDocumentsDirectoryForFile:(NSString *)fileName;
+ (NSString *)getLibraryDirectoryForFile:(NSString *)fileName;
+ (NSString *)getCacheDirectoryForFile:(NSString *)fileName;

+ (NSString *)convertToUTF8Entities:(NSString *)string;
+ (NSString *)standardizeFromUTF8Entities:(NSString *)string;
+ (NSString *)replaceAllSpecialSymbolsOfString:(NSString *)original withString:(NSString *)string;
+ (NSString *)removeAllHTMLTags:(NSString *)original;

+ (NSString *)detectDeviceModel;

- (BOOL)isNumeric;

@end
