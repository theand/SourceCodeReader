
//  Created by Ignacio Romero Zurbuchen on 10/28/11.
//  Copyright (c) 2011 DZen Interaktiv. All rights reserved.
//

#import "NSString+DZEN.h"
#include <sys/utsname.h>

@implementation NSString (DZEN)

+ (NSString *)cleanWhiteSpacesFrom:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return string;
}

+ (NSString *)replaceWhiteSpacesFrom:(NSString *)string with:(NSString *)symbol
{
    string = [string stringByReplacingOccurrencesOfString:@" " withString:symbol];
    return string;
}

+ (NSString *)getBundlePathForFile:(NSString *)fileName
{
    NSString *fileExtension = [fileName pathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource:[fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",fileExtension] withString:@""] ofType:fileExtension];
    return path;
}

+ (NSString *)getDocumentsDirectoryForFile:(NSString *)fileName
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",fileName]];
    return path;
}

+ (NSString *)getLibraryDirectoryForFile:(NSString *)fileName
{
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",fileName]];
    return destinationPath;
}

+ (NSString *)getCacheDirectoryForFile:(NSString *)fileName
{
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",fileName]];
    return destinationPath;
}


+ (NSString *)convertToUTF8Entities:(NSString *)string
{
    NSString *isoEncodedString = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
    [string stringByReplacingOccurrencesOfString:@"%27" withString:@"'"]
    stringByReplacingOccurrencesOfString:[@"%e2%80%99" capitalizedString] withString:@"’"]
    stringByReplacingOccurrencesOfString:[@"%2d" capitalizedString] withString:@"-"]
    stringByReplacingOccurrencesOfString:[@"%c2%ab" capitalizedString] withString:@"«"]
    stringByReplacingOccurrencesOfString:[@"%c2%bb" capitalizedString] withString:@"»"]
    stringByReplacingOccurrencesOfString:[@"%c3%80" capitalizedString] withString:@"À"]
    stringByReplacingOccurrencesOfString:[@"%c3%82" capitalizedString] withString:@"Â"]
    stringByReplacingOccurrencesOfString:[@"%c3%84" capitalizedString] withString:@"Ä"]
    stringByReplacingOccurrencesOfString:[@"%c3%86" capitalizedString] withString:@"Æ"]
    stringByReplacingOccurrencesOfString:[@"%c3%87" capitalizedString] withString:@"Ç"]
    stringByReplacingOccurrencesOfString:[@"%c3%88" capitalizedString] withString:@"È"]
    stringByReplacingOccurrencesOfString:[@"%c3%89" capitalizedString] withString:@"É"]
    stringByReplacingOccurrencesOfString:[@"%c3%8a" capitalizedString] withString:@"Ê"]
    stringByReplacingOccurrencesOfString:[@"%c3%8b" capitalizedString] withString:@"Ë"]
    stringByReplacingOccurrencesOfString:[@"%c3%8f" capitalizedString] withString:@"Ï"]
    stringByReplacingOccurrencesOfString:[@"%c3%91" capitalizedString] withString:@"Ñ"]
    stringByReplacingOccurrencesOfString:[@"%c3%94" capitalizedString] withString:@"Ô"]
    stringByReplacingOccurrencesOfString:[@"%c3%96" capitalizedString] withString:@"Ö"]
    stringByReplacingOccurrencesOfString:[@"%c3%9b" capitalizedString] withString:@"Û"]
    stringByReplacingOccurrencesOfString:[@"%c3%9c" capitalizedString] withString:@"Ü"]
    stringByReplacingOccurrencesOfString:[@"%c3%a0" capitalizedString] withString:@"à"]
    stringByReplacingOccurrencesOfString:[@"%c3%a2" capitalizedString] withString:@"â"]
    stringByReplacingOccurrencesOfString:[@"%c3%a4" capitalizedString] withString:@"ä"]
    stringByReplacingOccurrencesOfString:[@"%c3%a6" capitalizedString] withString:@"æ"]
    stringByReplacingOccurrencesOfString:[@"%c3%a7" capitalizedString] withString:@"ç"]
    stringByReplacingOccurrencesOfString:[@"%c3%a8" capitalizedString] withString:@"è"]
    stringByReplacingOccurrencesOfString:[@"%c3%a9" capitalizedString] withString:@"é"]
    stringByReplacingOccurrencesOfString:[@"%c3%af" capitalizedString] withString:@"ï"]
    stringByReplacingOccurrencesOfString:[@"%c3%b4" capitalizedString] withString:@"ô"]
    stringByReplacingOccurrencesOfString:[@"%c3%b6" capitalizedString] withString:@"ö"]
    stringByReplacingOccurrencesOfString:[@"%c3%bb" capitalizedString] withString:@"û"]
    stringByReplacingOccurrencesOfString:[@"%c3%bc" capitalizedString] withString:@"ü"]
    stringByReplacingOccurrencesOfString:[@"%c3%bf" capitalizedString] withString:@"ÿ"]
    stringByReplacingOccurrencesOfString:@"%20" withString:@" "];

    return isoEncodedString;
}

+ (NSString *)standardizeFromUTF8Entities:(NSString *)string
{
     NSString *isoEncodedString = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
     [string stringByReplacingOccurrencesOfString:@"'" withString:@""]
     stringByReplacingOccurrencesOfString:@"’" withString:@""]
     stringByReplacingOccurrencesOfString:@"«" withString:@""]
     stringByReplacingOccurrencesOfString:@"»" withString:@""]
     stringByReplacingOccurrencesOfString:@"À" withString:@"A"]
     stringByReplacingOccurrencesOfString:@"Â" withString:@"A"]
     stringByReplacingOccurrencesOfString:@"Ä" withString:@"A"]
     stringByReplacingOccurrencesOfString:@"Æ" withString:@"AE"]
     stringByReplacingOccurrencesOfString:@"Ç" withString:@"C"]
     stringByReplacingOccurrencesOfString:@"È" withString:@"E"]
     stringByReplacingOccurrencesOfString:@"É" withString:@"E"]
     stringByReplacingOccurrencesOfString:@"Ê" withString:@"E"]
     stringByReplacingOccurrencesOfString:@"Ë" withString:@"E"]
     stringByReplacingOccurrencesOfString:@"Ï" withString:@"I"]
     stringByReplacingOccurrencesOfString:@"Ñ" withString:@"N"]
     stringByReplacingOccurrencesOfString:@"Ô" withString:@"O"]
     stringByReplacingOccurrencesOfString:@"Ö" withString:@"O"]
     stringByReplacingOccurrencesOfString:@"Û" withString:@"U"]
     stringByReplacingOccurrencesOfString:@"Ü" withString:@"U"]
     stringByReplacingOccurrencesOfString:@"à" withString:@"a"]
     stringByReplacingOccurrencesOfString:@"â" withString:@"a"]
     stringByReplacingOccurrencesOfString:@"ä" withString:@"a"]
     stringByReplacingOccurrencesOfString:@"æ" withString:@"ae"]
     stringByReplacingOccurrencesOfString:@"ç" withString:@"c"]
     stringByReplacingOccurrencesOfString:@"è" withString:@"e"]
     stringByReplacingOccurrencesOfString:@"é" withString:@"e"]
     stringByReplacingOccurrencesOfString:@"ï" withString:@"i"]
     stringByReplacingOccurrencesOfString:@"ô" withString:@"o"]
     stringByReplacingOccurrencesOfString:@"ö" withString:@"o"]
     stringByReplacingOccurrencesOfString:@"û" withString:@"u"]
     stringByReplacingOccurrencesOfString:@"ü" withString:@"u"]
     stringByReplacingOccurrencesOfString:@"ÿ" withString:@"y"];
     
     return isoEncodedString;
}

+ (NSString *)replaceAllSpecialSymbolsOfString:(NSString *)original withString:(NSString *)string
{
    NSString *simplifiedString = [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[
    [original stringByReplacingOccurrencesOfString:@"/" withString:string]
    stringByReplacingOccurrencesOfString:@"=" withString:string]
    stringByReplacingOccurrencesOfString:@"+" withString:string]
    stringByReplacingOccurrencesOfString:@"-" withString:string]
    stringByReplacingOccurrencesOfString:@"#" withString:string]
    stringByReplacingOccurrencesOfString:@"]" withString:string]
    stringByReplacingOccurrencesOfString:@"[" withString:string]
    stringByReplacingOccurrencesOfString:@"{" withString:string]
    stringByReplacingOccurrencesOfString:@"}" withString:string]
    stringByReplacingOccurrencesOfString:@"^" withString:string]
    stringByReplacingOccurrencesOfString:@"*" withString:string]
    stringByReplacingOccurrencesOfString:@"¿" withString:string]
    stringByReplacingOccurrencesOfString:@"?" withString:string]
    stringByReplacingOccurrencesOfString:@"¡" withString:string]
    stringByReplacingOccurrencesOfString:@"@" withString:string]
    stringByReplacingOccurrencesOfString:@"¶" withString:string]
    stringByReplacingOccurrencesOfString:@"€" withString:string]
    stringByReplacingOccurrencesOfString:@"£" withString:string]
    stringByReplacingOccurrencesOfString:@"₤" withString:string]
    stringByReplacingOccurrencesOfString:@"¥" withString:string]
    stringByReplacingOccurrencesOfString:@"%" withString:string]
    stringByReplacingOccurrencesOfString:@"<" withString:string]
    stringByReplacingOccurrencesOfString:@">" withString:string]
    stringByReplacingOccurrencesOfString:@"|" withString:string]
    stringByReplacingOccurrencesOfString:@"¨" withString:string]
    stringByReplacingOccurrencesOfString:@"`" withString:string]
    stringByReplacingOccurrencesOfString:@"\"" withString:string]
    stringByReplacingOccurrencesOfString:@"&" withString:string]
    stringByReplacingOccurrencesOfString:@"˝" withString:string]
    stringByReplacingOccurrencesOfString:@"Œ" withString:string]
    stringByReplacingOccurrencesOfString:@"∆" withString:string]
    stringByReplacingOccurrencesOfString:@"ﬁ" withString:string]
    stringByReplacingOccurrencesOfString:@"¯" withString:string]
    stringByReplacingOccurrencesOfString:@"‹" withString:string]
    stringByReplacingOccurrencesOfString:@"Ω" withString:string]
    stringByReplacingOccurrencesOfString:@"∑" withString:string]
    stringByReplacingOccurrencesOfString:@"©" withString:string]
    stringByReplacingOccurrencesOfString:@"√" withString:string]
    stringByReplacingOccurrencesOfString:@"∏" withString:string]
    stringByReplacingOccurrencesOfString:@"±" withString:string]
    stringByReplacingOccurrencesOfString:@"˘" withString:string]
    stringByReplacingOccurrencesOfString:@"Ø" withString:string]
    stringByReplacingOccurrencesOfString:@"⁄" withString:string]
    stringByReplacingOccurrencesOfString:@"≥" withString:string]
    stringByReplacingOccurrencesOfString:@"•" withString:string];
    
    return simplifiedString;
}

+ (NSString *)removeAllHTMLTags:(NSString *)original 
{
    NSString *cleanString = [[[[[original stringByReplacingOccurrencesOfString:@"<b>" withString:@""]
                             stringByReplacingOccurrencesOfString:@"</b>" withString:@""]
                             stringByReplacingOccurrencesOfString:@"<l>" withString:@""]
                             stringByReplacingOccurrencesOfString:@"</l>" withString:@""]
                             stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    
    return cleanString;
}

+ (NSString *)detectDeviceModel
{
    struct utsname platform;
    int rc = uname(&platform);
    if(rc == -1)
    {
        NSLog(@"detectDeviceModel: Error");
        return nil;
    }
    else
    {
        NSString *device = [NSString stringWithCString:platform.machine encoding:NSUTF8StringEncoding];
        return [device substringToIndex:[device length] - 2];
    }
}

- (BOOL)isNumeric
{
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    return [alphaNumbersSet isSupersetOfSet:stringSet];
}

@end
