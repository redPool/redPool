//
//  UIView+DVView.m
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/6/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import "UIView+DVView.h"
#import "DVCustomizer.h"
#import <objc/runtime.h>

NSString * const kDVCustomType = @"kDVCustomType";

@implementation UIView (DVView)

static IMP __original_layoutSubviews_Imp;

void dv_layoutSubviews_Imp(id self, SEL _cmd) {
    __weak typeof(self)weakSelf = self;
    
    if ([DVSettingsViewController shouldShowAtInit]) {
    
        [[NSNotificationCenter defaultCenter] addObserverForName:kCustomizationReloadNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      __strong __typeof(weakSelf)strongSelf = weakSelf;
                                                      if (strongSelf) {
                                                          if ([strongSelf respondsToSelector:@selector(layoutSubviews)]) {
                                                              [strongSelf layoutSubviews];
                                                          } else {
                                                              [[strongSelf superview] layoutSubviews];
                                                          }
                                                      }
                                                  }];
    }
    [[DVCustomizer sharedManager]customizeComponent:self];
    
    ((void( *)(id, SEL))__original_layoutSubviews_Imp)(self, _cmd);
}

- (void)setDvCustomType:(NSString *)dvCustomType {
	objc_setAssociatedObject(self, (__bridge const void *)(kDVCustomType), dvCustomType, OBJC_ASSOCIATION_COPY);
}

- (NSString *)dvCustomType {
	return objc_getAssociatedObject(self, (__bridge const void *)(kDVCustomType));
}

+ (void)load {
    
    static dispatch_once_t swizzleLayoutSubviewsToken;
	dispatch_once(&swizzleLayoutSubviewsToken, ^{
		Method m = class_getInstanceMethod([self class], @selector(layoutSubviews));
        __original_layoutSubviews_Imp = method_setImplementation(m, (IMP)dv_layoutSubviews_Imp);
	});
}

@end
