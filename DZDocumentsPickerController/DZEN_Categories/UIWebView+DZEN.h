
//  Created by Ignacio Romero Zurbuchen on 2/12/12.
//  Copyright (c) 2012 DZen Interaktiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h> 

@interface UIWebView (DZEN)

- (float)contentHeight;
- (CGSize)windowSize;
- (CGPoint)scrollOffset;

- (void)removeBackgroundShadow;

- (void)enableInput:(BOOL)enable;
- (void)enableUserSelection:(BOOL)enable;

@end
