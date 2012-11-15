//
//  ViewController.h
//  SourceCodeReader
//
//  Created by sdt5 on 11/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SourcePickerController;

@interface ViewController : UIViewController{
}
@property (nonatomic, strong) IBOutlet UIWebView *myWebView;
@property (nonatomic, strong) UIPopoverController *sourcePickerPopover;
@property (nonatomic, strong) SourcePickerController *sourcePickerController;

- (IBAction)viewSourceList:(id)sender;

@end
