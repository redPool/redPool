//
//  UIColor+RPUtils.h
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

// Native Frameworks
@import UIKit;

@interface UIColor (RPUtils)

+ (UIColor *)colorFromHexString:(NSString *)color;
+ (NSString *)hexStringFromColor:(UIColor *)color;
- (CGFloat) red;
- (CGFloat) green;
- (CGFloat) blue;
- (CGFloat) alpha;

@end
