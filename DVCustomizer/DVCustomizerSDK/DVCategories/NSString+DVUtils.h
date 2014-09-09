//
//  NSString+DVUtils.h
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

// Native Frameworks
@import Foundation;

@interface NSString (DVUtils)

- (NSString *)getProperStringBasedOnDevice;
- (NSString *)getStringForPhone;
- (NSString *)getStringForPad;

@end
