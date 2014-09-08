//
//  UIColor+DVUtils.h
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DVUtils)

+ (UIColor *)colorFromHexString:(NSString *)color;
+ (NSString *)hexStringFromColor:(UIColor *)color;
- (CGFloat) red;
- (CGFloat) green;
- (CGFloat) blue;
- (CGFloat) alpha;

@end
