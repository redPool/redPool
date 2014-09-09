//
//  UIView+DVView.h
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/6/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DVView)

@property (nonatomic, copy) NSString *dvCustomType;

void dv_layoutSubviews_Imp(id self, SEL _cmd);

@end
