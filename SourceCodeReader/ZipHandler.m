//
// Created by sdt5 on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "ZipHandler.h"


@implementation ZipHandler {

}


+ (NSString *)getDocumentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(BOOL)fileExistsAtAbsolutePath:(NSString*)filename {
    BOOL isDirectory;
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory];

    return fileExistsAtPath && !isDirectory;
}

+(BOOL)directoryExistsAtAbsolutePath:(NSString*)filename {
    BOOL isDirectory;
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory];

    return fileExistsAtPath && isDirectory;
}

+ (void)ensureTargetDirectory:(NSString *)target {
    NSError *theError = nil;
    BOOL dirExists = [ZipHandler directoryExistsAtAbsolutePath:target];
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


+ (void)ensureIntermediatePathOfFile:(NSString *)path {
    NSMutableArray *components = [NSMutableArray arrayWithArray:[path pathComponents]];
    if ([components count] <2){
        DebugLog(@"no intermediate path for %@", path);
        return;
    }

    DebugLog(@"getting containing folder for %@", path);
    [components removeLastObject];
    NSString *containingDirectory = [NSString pathWithComponents:components];
    DebugLog(@"containgFolder: %@", containingDirectory);

    [ZipHandler ensureTargetDirectory:containingDirectory];
}


+ (NSString *)saveToImportDirectory:(NSData *)data extension:(NSString *)extension name:(NSString *)name {
    NSString *documentsDirectory = [ZipHandler getDocumentsPath];

    //TODO - 같은 파일 있을 경우 처리

    NSString *fileName = [NSString stringWithFormat:@"import/%@.%@", name, extension];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
    DebugLog(@"filePath saving: %@", filePath);
    return filePath;
}

+ (void)extractToProjectFromZip:(NSString *)zipPath {
    ZZArchive *zipArchive = [ZZArchive archiveWithContentsOfURL:[NSURL fileURLWithPath:zipPath]];

    //압축 파일의 이름으로 최상위 디렉토리를 생성.
    NSString *zipProjectName =[
            [
                [ZipHandler getDocumentsPath] stringByAppendingPathComponent:@"Project"
            ]
                stringByAppendingPathComponent:[
                    [zipPath lastPathComponent] stringByDeletingPathExtension
                ]
        ];
    [ZipHandler ensureTargetDirectory:zipProjectName];

    for (ZZArchiveEntry *entry in zipArchive.entries) {
        NSString *fileType = nil;
        NSString *entryPath = [zipProjectName stringByAppendingPathComponent:entry.fileName];

        if (entry.fileMode & S_IFDIR) {
            fileType = @"DIR";
            [ZipHandler ensureTargetDirectory:entryPath];
        } else if (entry.fileMode & S_IFREG) {
            fileType = @"REGULAR";
            if ( ! [ZipHandler saveRegularFileToProject:entry entryPath:entryPath] )
                break;
        } else if ( entry.fileMode &  S_IFMT){
            fileType = @"S_IFMT";
        } else if ( entry.fileMode & S_IFIFO){
            fileType = @"S_IFIFO";
        } else if ( entry.fileMode & S_IFCHR){
            fileType = @"S_IFCHR";
        } else if ( entry.fileMode & S_IFBLK){
            fileType = @"S_IFBLK";
        } else if ( entry.fileMode & S_IFLNK){
            fileType = @"S_IFLNK";
        } else if ( entry.fileMode & S_IFSOCK){
            fileType = @"S_IFSOCK";
        }else{
            //TODO 여기에 오는 애들 뭔지 모르겠다.
            fileType = @"What Is It!";
            if ([entry.fileName hasSuffix:@"/"] ){
                [ZipHandler ensureTargetDirectory:entryPath];
            }else{
            if ( ! [ZipHandler saveRegularFileToProject:entry entryPath:entryPath])
                break;
            }
        }
        DebugLog(@"filename : %@ - %d bytes - %o - %@", entry.fileName, entry.uncompressedSize, entry.fileMode, fileType);
    }
}

+ (BOOL)saveRegularFileToProject:(ZZArchiveEntry *)entry entryPath:(NSString *)entryPath {
    [ZipHandler ensureIntermediatePathOfFile:entryPath];\

    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm createFileAtPath:entryPath contents:entry.data attributes:nil]) {
        DebugLog(@"ERROR!! in createFile - %@", entryPath );
        return NO;
    }else{
        return YES;
    }
}


@end
