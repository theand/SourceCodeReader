
//  Created by Ignacio Romero Zurbuchen on 2/12/12.
//  Copyright (c) 2012 DZen Interaktiv. All rights reserved.
//

#import "UIWebView+DZEN.h"

@implementation UIWebView (DZEN)

- (float)contentHeight
{
	return [[self stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight + document.body.offsetTop;"] floatValue];
}

- (CGSize)windowSize
{
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)scrollOffset
{
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}

- (void)removeBackgroundShadow
{
    for (UIView *eachSubview in [self.scrollView subviews])
    {
        if ([eachSubview isKindOfClass:[UIImageView class]] && eachSubview.frame.origin.x <= 500)
        {
            eachSubview.hidden = YES;
            [eachSubview removeFromSuperview];
        }
    }
}

- (void)enableInput:(BOOL)enable;
{
    UIScrollView *webViewContentView;
    for (UIView *checkView in [self subviews])
    {
        if ([checkView isKindOfClass:[UIScrollView class]])
        {
            webViewContentView = (UIScrollView *)checkView;
            [webViewContentView setScrollEnabled:enable];
            break;
        }
    }
    
    for (UIView *checkView in [webViewContentView subviews])
    {
        if ([checkView.gestureRecognizers count] > 0)
        {
            checkView.userInteractionEnabled = enable;
            
            for (UIGestureRecognizer *gesture in checkView.gestureRecognizers)
                gesture.enabled = enable;
        }
    }
}

- (void)enableUserSelection:(BOOL)enable
{
    NSString *value;
    if (enable) value = @"auto";
    else value = @"none";
    
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.webkitTouchCallout='%@';",value]];
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.webkit-touch-callout='%@';",value]];
    
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.webkitUserSelect='%@';",value]];
    [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.webkit-user-select='%@';",value]];
}

@end
