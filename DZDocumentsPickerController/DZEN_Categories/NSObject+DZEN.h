
//  Created by Ignacio Romero Zurbuchen on 3/1/12.
//  Copyright (c) 2012 DZen Interaktiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DZEN)

- (void)deleteLocalFile:(NSString *)filename;
- (void)moveLocalFile:(NSString *)fileName fromDirectory:(NSString *)origin toDirectory:(NSString *)destination withFolderName:(NSString *)folderName;
- (void)duplicateFileAtPath:(NSString *)origin toNewPath:(NSString *)destination;
- (void)renameFileAtPath:(NSString *)path withOldName:(NSString *)oldName andNewName:(NSString *)newName;

- (id)getSettings:(NSString *)settings ObjectForKey:(NSString *)objKey;
- (void)setSettings:(NSString *)settings Object:(id)value forKey:(NSString *)objKey;

- (BOOL)isRetina;
- (BOOL)isIOS5;

@end
