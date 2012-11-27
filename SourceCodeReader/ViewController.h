//
//  ViewController.h
//  SourceCodeReader
//
//  Created by sdt5 on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourcePickerController.h"

@class DZDocumentsPickerController;
@class KOTreeViewController;

@interface ViewController : UIViewController{
}
@property (nonatomic, strong) IBOutlet UIWebView *myWebView;

@property (nonatomic, strong) SourcePickerController *sourcePickerController;
@property (nonatomic, strong) UIPopoverController *sourcePickerPopOverController;

@property (nonatomic, strong) DZDocumentsPickerController *dropboxPickerController;
@property (nonatomic, strong) UIPopoverController *dropboxPickerPopOverController;

@property (nonatomic, strong) KOTreeViewController *projectPickerController;
@property (nonatomic, strong) UIPopoverController *projectPickerPopOverController;


- (IBAction)viewSourceList:(id)sender;
- (IBAction)goDropbox:(id)sender;
- (IBAction)viewProjectDirectory:(id)sender;
- (IBAction)closeProjectDirectory:(id)sender;

@end
