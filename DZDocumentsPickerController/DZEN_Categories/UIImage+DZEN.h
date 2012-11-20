
//  Created by Ignacio Romero Zurbuchen on 12/29/11.
//  Copyright (c) 2011 DZen Interaktiv. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface UIImage (DZEN)
{
    
}

//Blending Effects
- (UIImage *)blendOverlay;

//Masking
- (UIImage *)maskWithImage:(UIImage *)img andSize:(CGSize)size;
- (UIImage *)maskWithImage:(UIImage *)img;
- (UIImage *)stampWithImage:(UIImage *)img;

//Scaling & Cropping
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToMaximumSize:(CGSize)maxSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

//Alpha Channel Changing
- (BOOL)hasAlpha;
- (UIImage *)removeAlpha;
- (UIImage *)fillAlpha;
- (UIImage *)fillAlphaWithColor:(UIColor *)color;

//Color Mode Changing
- (BOOL)isGrayscale;
- (UIImage *)imageToGrayscale;
- (UIImage *)imageToBlackAndWhite;
- (UIImage *)invertColors;

@end
