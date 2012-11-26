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

    NSString *fileName = [NSString stringWithFormat:@"import/%@.%@", name, extension];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
    DebugLog(@"filePath saving: %@", filePath);
    return filePath;
}

+ (void)extractToProjectFromZip:(NSString *)zipPath {
    ZZArchive *zipArchive = [ZZArchive archiveWithContentsOfURL:[NSURL fileURLWithPath:zipPath]];

    NSString *pathForProject = [[self getDocumentsPath] stringByAppendingPathComponent:@"Project"];

    //TODO 압축 파일 이름으로 먼저 디렉토리를 만드는게 나을듯?
    for (ZZArchiveEntry *entry in zipArchive.entries) {
        NSString *fileType = nil;
        NSString *entryPath = [pathForProject stringByAppendingPathComponent:entry.fileName];

        if (entry.fileMode & S_IFDIR) {
            fileType = @"DIR";
            [self ensureTargetDirectory:entryPath];
        } else if (entry.fileMode & S_IFREG) {
            fileType = @"REGULAR";
            [ZipHandler saveRegularFileToProject:entry entryPath:entryPath];
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
            fileType = @"What Is It!";
            [ZipHandler saveRegularFileToProject:entry entryPath:entryPath];
            //TODO 여기에 오는 애들 뭔지 모르겠다.
        }
        DebugLog(@"filename : %@ - %d bytes - %o - %@", entry.fileName, entry.uncompressedSize, entry.fileMode, fileType);
    }
}

+ (void)saveRegularFileToProject:(ZZArchiveEntry *)entry entryPath:(NSString *)entryPath {
    [self ensureIntermediatePathOfFile:entryPath];\

    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm createFileAtPath:entryPath contents:entry.data attributes:nil]) {
        DebugLog(@"ERROR!! in createFile - %@", entryPath );
    }
}


@end
