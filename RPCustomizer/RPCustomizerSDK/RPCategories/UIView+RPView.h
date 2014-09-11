//
//  UIView+RPView.h
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/6/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

// Native Frameworks
@import UIKit;

@interface UIView (RPView)

@property (nonatomic, copy) NSString *rpCustomType;
@property (nonatomic, readwrite) BOOL rpAlreadyCustomized;
@property (nonatomic, readwrite) BOOL rpAlreadyAddedObserver;

@end
