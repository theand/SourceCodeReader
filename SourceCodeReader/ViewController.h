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

@interface ViewController : UIViewController{
}
@property (nonatomic, strong) IBOutlet UIWebView *myWebView;
@property (nonatomic, strong) UIPopoverController *sourcePickerPopover;
@property (nonatomic, strong) SourcePickerController *sourcePickerController;
@property (nonatomic, strong) DZDocumentsPickerController *docPickerController;
@property (nonatomic, strong) UIPopoverController *docPickerPopOverController;

- (IBAction)viewSourceList:(id)sender;
- (IBAction)goDropbox:(id)sender;

@end
