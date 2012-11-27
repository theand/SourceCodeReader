//
// Created by sdt5 on 12. 11. 26..
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "ZipHandler.h"


@implementation ZipHandler {

}

+ (NSString *)saveToImportDirectory:(NSData *)data extension:(NSString *)extension name:(NSString *)name {
    NSString *documentsDirectory = [self getDocumentsPath];

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
                [self getDocumentsPath] stringByAppendingPathComponent:@"Project"
            ]
                stringByAppendingPathComponent:[
                    [zipPath lastPathComponent] stringByDeletingPathExtension
                ]
        ];
    [self ensureTargetDirectory:zipProjectName];

    for (ZZArchiveEntry *entry in zipArchive.entries) {
        NSString *fileType = nil;
        NSString *entryPath = [zipProjectName stringByAppendingPathComponent:entry.fileName];

        if (entry.fileMode & S_IFDIR) {
            fileType = @"DIR";
            [self ensureTargetDirectory:entryPath];
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
                [self ensureTargetDirectory:entryPath];
            }else{
            if ( ! [ZipHandler saveRegularFileToProject:entry entryPath:entryPath])
                break;
            }
        }
        DebugLog(@"filename : %@ - %d bytes - %o - %@", entry.fileName, entry.uncompressedSize, entry.fileMode, fileType);
    }
}

+ (BOOL)saveRegularFileToProject:(ZZArchiveEntry *)entry entryPath:(NSString *)entryPath {
    [self ensureIntermediatePathOfFile:entryPath];\

    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm createFileAtPath:entryPath contents:entry.data attributes:nil]) {
        DebugLog(@"ERROR!! in createFile - %@", entryPath );
        return NO;
    }else{
        return YES;
    }
}


@end
