//
//  AppDelegate.h
//  SourceCodeReader
//
//  Created by sdt5 on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK/DropboxSDK.h"
#import "DZCategories.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//Dropbox Session Universal Object
@property (nonatomic, strong) DBSession *dbSession;
@property (nonatomic, strong) NSString *relinkUserId;


- (void)startDropboxSession;


@end
