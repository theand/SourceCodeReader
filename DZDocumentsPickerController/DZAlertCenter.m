
//
//  DZAlertCenter.h
//  DZDocumentsPickerController
//
//  Created Ignacio Romero Zurbuchen on 5/4/12.
//  Copyright (c) 2011 DZen Interaktiv.
//  Licence: MIT-Licence
//

#import "DZAlertCenter.h"

@implementation DZAlertCenter
@synthesize alert, alertMode, firstAction, secondAction, uploadProgressView;

static DZAlertCenter *_sharedCenter = nil;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (DZAlertCenter *)sharedCenter
{
    return _sharedCenter;
}

+ (void)setSharedCenter:(DZAlertCenter *)center
{
    if (center == _sharedCenter) return;
    _sharedCenter = center;
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)mssg cancelButtonTitle:(NSString *)cancelTitle withTarget:(id)target andSingleAction:(NSString *)selector
{
    if (selector) [self setupTarget:target andSelectors:[NSArray arrayWithObject:selector]];
    
    alert = [[UIAlertView alloc] initWithTitle:title message:mssg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    [alert show];
}

- (void)loadingAlertWithTitle:(NSString *)title message:(NSString *)mssg cancelButtonTitle:(NSString *)cancelTitle withTarget:(id)target andSingleAction:(NSString *)selector
{
    [self setupTarget:target andSelectors:[NSArray arrayWithObject:selector]];
    
    alert = [[UIAlertView alloc] initWithTitle:title message:mssg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [self setUploadProgressView:nil];
    uploadProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 100.0f, 225.0f, 90.0f)];
    [uploadProgressView setProgressViewStyle:UIProgressViewStyleBar];
    [alert addSubview:uploadProgressView];
    
    [alert show];
}

- (void)loginActionAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle actionButtonTitle:(NSString *)actionTitle withTarget:(id)target andActions:(NSArray *)someSelectors;
{
    [self setupTarget:target andSelectors:someSelectors];
    
    alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:actionTitle,nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    UITextField *emailTxtField = [alert textFieldAtIndex:0];
    emailTxtField.placeholder = @"Email";
    UITextField *passwordTxtField = [alert textFieldAtIndex:1];
    passwordTxtField.placeholder = @"Password";
    
    [alert show];
}

- (void)setupTarget:(id)atarget andSelectors:(NSArray *)someSelectors
{
    actionTarget = nil;
    actionTarget = atarget;
    
    selectors = nil;
    selectors = someSelectors;
}

- (void)noActionAlertWithTitle:(NSString *)title withMessage:(NSString *)mssg withCancelButton:(NSString *)btnTitle
{
    alert = [[UIAlertView alloc] initWithTitle:title message:mssg delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil];
    [alert show];
}

- (void)noInternetConnectionAlert
{
    alertMode = @"noInternet";
    alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection"
                                       message:@"No Internet connection detected. Please check your Internet connection or try again later."
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}

- (void)closeAlertView
{
    if (alert)
    {
        [alert dismissWithClickedButtonIndex:0 animated:TRUE];
        alert = nil;
    }
}

@end
