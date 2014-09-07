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

+ (UIColor *)colorFromHexString:(NSString *)color {
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

@end
