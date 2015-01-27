//
//  UIView+RPView.m
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/6/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

// Header
#import "UIView+RPView.h"

// Utilities
#import "RPCustomizer.h"

// Native Frameworks
@import ObjectiveC;

// Constants
#import "RPConstants.h"

/**
 *	Custom type key for the objective runtime association.
 *
 *	@since 1.0.0
 */
static void *kRPCustomType = &kRPCustomType;
static void *kRPAlreadyCustomized = &kRPAlreadyCustomized;
static void *kRPAlreadyAddedObserver = &kRPAlreadyAddedObserver;

@interface UIView ()

void rp_layoutSubviews_Imp(id self, SEL _cmd);

@property (strong, nonatomic) id notificationObserver;

@end

@implementation UIView (RPView)

static IMP __original_layoutSubviews_Imp;

#pragma mark Properties

- (void)setRpCustomType:(NSString *)rpCustomType {
	objc_setAssociatedObject(self, kRPCustomType, rpCustomType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)rpCustomType {
	return objc_getAssociatedObject(self, kRPCustomType);
}

- (void)setRpAlreadyCustomized:(BOOL)rpAlreadyCustomized {
    NSNumber *number = [NSNumber numberWithBool: rpAlreadyCustomized];
    objc_setAssociatedObject(self, kRPAlreadyCustomized, number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL) rpAlreadyCustomized {
    NSNumber *number = objc_getAssociatedObject(self, kRPAlreadyCustomized);
    return [number boolValue];
}

- (void)setRpAlreadyAddedObserver:(BOOL)rpAlreadyAddedObserver {
    NSNumber *number = [NSNumber numberWithBool: rpAlreadyAddedObserver];
    objc_setAssociatedObject(self, kRPAlreadyAddedObserver, number , OBJC_ASSOCIATION_RETAIN);
}

- (BOOL) rpAlreadyAddedObserver {
    NSNumber *number = objc_getAssociatedObject(self, kRPAlreadyAddedObserver);
    return [number boolValue];
}

#pragma mark - Swizzling

void rp_layoutSubviews_Imp(id self, SEL _cmd) {
    [[RPCustomizer sharedManager] customizeComponent:self];
    
    ((void( *)(id, SEL))__original_layoutSubviews_Imp)(self, _cmd);
}

+ (void)load {
    static dispatch_once_t swizzleLayoutSubviewsToken;
	dispatch_once(&swizzleLayoutSubviewsToken, ^{
		Method m = class_getInstanceMethod([self class], @selector(layoutSubviews));
        __original_layoutSubviews_Imp = method_setImplementation(m, (IMP)rp_layoutSubviews_Imp);
	});
}

@end
