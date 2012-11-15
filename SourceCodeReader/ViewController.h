//
//  ViewController.h
//  SourceCodeReader
//
//  Created by sdt5 on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBRestClient;

@interface ViewController : UIViewController{
    DBRestClient *restClient;
}
@property (nonatomic, strong) IBOutlet UIWebView *myWebView;
- (IBAction)showSourceFile:(id)sender;
- (IBAction)dropboxLink:(id)sender;
- (IBAction)uploadToDropbox:(id)sender;
- (IBAction)listDropbox:(id)sender;
- (IBAction)downloadFileFromDropbox:(id)sender;

@end
