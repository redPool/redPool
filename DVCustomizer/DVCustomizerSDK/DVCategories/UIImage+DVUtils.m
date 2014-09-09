//
//  UIImage+DVUtils.m
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

#import "UIImage+DVUtils.h"

@implementation UIImage (DVUtils)

- (UIImage *)imageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
