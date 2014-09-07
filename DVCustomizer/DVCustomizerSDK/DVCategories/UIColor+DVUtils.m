//
//  UIColor+DVUtils.m
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import "UIColor+DVUtils.h"
#import "NSString+DVUtils.h"


@implementation UIColor (DVUtils)

- (UIColor *)colorFromHexString:(NSString *)color {
    if (!color
        || [color isEqualToString:@""]) {
        return [UIColor clearColor];
    }
    
    NSString *cleanString = [color stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    cleanString = [cleanString getProperStringBasedOnDevice];
    
    NSArray *saturationObjects = [cleanString componentsSeparatedByString:@"("];
    CGFloat saturation = 1.0f;
    
    if ([saturationObjects count] > 1) {
        NSString *saturationStr = [saturationObjects objectAtIndex:1];
        saturationStr = [saturationStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        saturation = [saturationStr floatValue];
        cleanString = [saturationObjects objectAtIndex:0];
    }
    
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF) / 255.0f;
    float green = ((baseValue >> 16) & 0xFF) / 255.0f;
    float blue = ((baseValue >> 8) & 0xFF) / 255.0f;
    //    float alpha = ((baseValue >> 0) & 0xFF) / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:saturation];
}

- (NSString *)hexStringFromColor {
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use hexStringFromColor");
    
    CGFloat r, g, b;
    r = self.red;
    g = self.green;
    b = self.blue;
    
    // Fix range if needed
    if (r < 0.0f) r = 0.0f;
    if (g < 0.0f) g = 0.0f;
    if (b < 0.0f) b = 0.0f;
    
    if (r > 1.0f) r = 1.0f;
    if (g > 1.0f) g = 1.0f;
    if (b > 1.0f) b = 1.0f;
    
    // Convert to hex string between 0x00 and 0xFF
    return [NSString stringWithFormat:@"%02X%02X%02X",
            (int)(r * 255), (int)(g * 255), (int)(b * 255)];
}

- (CGColorSpaceModel) colorSpaceModel
{
	return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (BOOL) canProvideRGBComponents
{
	return (([self colorSpaceModel] == kCGColorSpaceModelRGB) ||
			([self colorSpaceModel] == kCGColorSpaceModelMonochrome));
}

- (CGFloat) red
{
	NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[0];
}

- (CGFloat) green
{
	NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
	return c[1];
}

- (CGFloat) blue
{
	NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
	return c[2];
}

- (CGFloat) alpha
{
	const CGFloat *c = CGColorGetComponents(self.CGColor);
	return c[CGColorGetNumberOfComponents(self.CGColor)-1];
}

@end
