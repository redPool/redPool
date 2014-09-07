//
//  NSString+DVUtils.m
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import "NSString+DVUtils.h"

#define INTERFACE_IS_IPHONE                         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone

@implementation NSString (DVUtils)

- (NSString *)getProperStringBasedOnDevice {
    NSString *result = self;
    NSArray *components = [self componentsSeparatedByString:@":"];
    
    if ([components count] > 1) {
        result = (INTERFACE_IS_IPHONE) ? [components objectAtIndex:0] : [components objectAtIndex:1];
    }
    
    return result;
}

@end
