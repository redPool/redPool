//
//  NSString+RPUtils.h
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

// Native Frameworks
@import Foundation;

@interface NSString (RPUtils)

- (NSString *)getProperStringBasedOnDevice;

@property (nonatomic, strong) NSString *first;
@property (nonatomic, strong) NSString *second;

@end
