
//  Created by Ignacio Romero Zurbuchen on 2/12/12.
//  Copyright (c) 2012 DZen Interaktiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (DZEN)
{
    
}

//Borders
- (void)createBordersWithColor:(UIColor *)color withCornerRadius:(CGFloat)radius andWidth:(CGFloat)width;
- (void)removeBorders;
- (void)removeShadow;

//Shadows
- (void)createRectShadowWithOffset:(CGSize)offset withOpacity:(CGFloat)opacity andRadius:(CGFloat)radius;
- (void)createCurlShadowWithAngle:(CGFloat)angle withOffset:(CGSize)offset withOpacity:(CGFloat)opacity andRadius:(CGFloat)radius;

@end
