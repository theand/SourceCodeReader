
//  Created by Ignacio Romero Zurbuchen on 3/1/12.
//  Copyright (c) 2012 DZen Interaktiv. All rights reserved.
//

#import "NSObject+DZEN.h"

@implementation NSObject (DZEN)

- (void)deleteLocalFile:(NSString *)filename
{
    if (filename.length > 0)
    {
        NSString *path = [NSString getLibraryDirectoryForFile:[NSString stringWithFormat:@"%@",filename]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            if ([[NSFileManager defaultManager] removeItemAtPath:path error:nil])
                NSLog(@"File deleted at path : %@",path);
        }
        else NSLog(@"Couldn't erase file at path : %@",path);
    }
}

- (void)moveLocalFile:(NSString *)fileName fromDirectory:(NSString *)origin toDirectory:(NSString *)destination withFolderName:(NSString *)folderName
{
    NSString *originPath = @"";
    if ([origin isEqualToString:@"mainbundle"]) originPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    else if ([origin isEqualToString:@"documents"]) originPath = [NSString getDocumentsDirectoryForFile:fileName];
    else if ([origin isEqualToString:@"library"]) originPath = [NSString getLibraryDirectoryForFile:fileName];
    
    /*Check if folder exist, if not, create automatically
    if (folderName.length > 0)
    {
        NSString *folderPath = [NSString stringWithFormat:@"%@/%@",destination,folderName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    */
    
    NSString *destinationPath;
    if ([destination isEqualToString:@"documents"]) destinationPath = [NSString getDocumentsDirectoryForFile:[NSString stringWithFormat:@"%@/%@",folderName,fileName]];
    else if ([destination isEqualToString:@"library"]) destinationPath = [NSString getLibraryDirectoryForFile:[NSString stringWithFormat:@"%@/%@",folderName,fileName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:originPath])
    {
        [[NSFileManager defaultManager] copyItemAtPath:originPath toPath:destinationPath error:nil];
        NSLog(@"movedLocalFile: %@ to path: %@",fileName,destinationPath);
    }
        
    else NSLog(@"\nError Moving file\nFrom: %@\nTo: %@",originPath,destinationPath);
    
    if (![origin isEqualToString:@"mainbundle"])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:originPath])
            [[NSFileManager defaultManager] removeItemAtPath:originPath error:nil];
    }
}

- (void)duplicateFileAtPath:(NSString *)origin toNewPath:(NSString *)destination
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:origin])
        [[NSFileManager defaultManager] copyItemAtPath:origin toPath:destination error:nil];
    else NSLog(@"\nError Moving file\nFrom: %@\nTo: %@",origin,destination);
}

- (void)renameFileAtPath:(NSString *)path withOldName:(NSString *)oldName andNewName:(NSString *)newName
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSString *newNamePath = [path stringByReplacingOccurrencesOfString:oldName withString:newName];
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:newNamePath error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    else NSLog(@"\nError Renaming file\nFrom : %@\nWith new name : %@",path,newName);  
}

- (id)getSettings:(NSString *)settings ObjectForKey:(NSString *)objKey;
{
    NSString *path = [NSString getLibraryDirectoryForFile:[NSString stringWithFormat:@"%@-Settings.plist",settings]];
    NSDictionary *loadedPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-Settings",settings] ofType:@"plist"];
        //[self moveLocalFile:@"App-Settings.plist" fromDirectory:@"mainbundle" toDirectory:@"library" withFolderName:@""];
        loadedPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return [loadedPlist objectForKey:objKey];
}

- (void)setSettings:(NSString *)settings Object:(id)value forKey:(NSString *)objKey;
{
    NSString *path = [NSString getLibraryDirectoryForFile:[NSString stringWithFormat:@"%@-Settings.plist",settings]];
    NSMutableDictionary *loadedPlist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-Settings",settings] ofType:@"plist"];
        [self moveLocalFile:[NSString stringWithFormat:@"%@-Settings.plist",settings] fromDirectory:@"mainbundle" toDirectory:@"library" withFolderName:@""];
        loadedPlist = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    
    [loadedPlist setObject:value forKey:objKey];
    [loadedPlist writeToFile:path atomically:NO];
}


- (BOOL)isRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) return YES;
    else return NO;
}


- (BOOL)isIOS5
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5) return true;
    else return false;
}


@end
