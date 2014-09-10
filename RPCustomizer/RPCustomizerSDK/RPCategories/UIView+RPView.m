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

@interface UIView ()

void dv_layoutSubviews_Imp(id self, SEL _cmd);

@property (strong, nonatomic) id notificationObserver;

@end

@implementation UIView (RPView)

static IMP __original_layoutSubviews_Imp;

#pragma mark Properties

- (void)setRpCustomType:(NSString *)dvCustomType {
	objc_setAssociatedObject(self, kRPCustomType, dvCustomType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)rpCustomType {
	return objc_getAssociatedObject(self, kRPCustomType);
}


#pragma mark - Swizzling

void dv_layoutSubviews_Imp(id self, SEL _cmd) {
    __weak typeof(self)weakSelf = self;
    
    if ([RPSettingsViewController shouldShowAtInit]) {
		// We need to get a hold of the notification observer to avoid leaking memory.
        [[NSNotificationCenter defaultCenter] addObserverForName:kRPCustomizationDictionaryChangedNotification
														  object:nil
														   queue:[NSOperationQueue mainQueue]
													  usingBlock:^(NSNotification *note) {
														  __strong __typeof(weakSelf)strongSelf = weakSelf;
														  if (strongSelf) {
															  // Check if the object reponds to `layoutSubviews`
															  if ([strongSelf respondsToSelector:@selector(layoutSubviews)]) {
																  [strongSelf layoutSubviews];
															  } else {
																  // If self doesn't responds to `layoutSubviews`
																  // we need to go up until a parent implements it or no more
																  // to go.
																  id superview = [strongSelf superview];
																  while (superview) {
																	  if ([superview respondsToSelector:@selector(layoutSubviews)]) {
																		  [superview layoutSubviews];
																		  
																		  break;
																	  } else {
																		  superview = [superview superview];
																	  }
																  }
															  }
														  }
													  }];
    }
    [[RPCustomizer sharedManager] customizeComponent:self];
    
    ((void( *)(id, SEL))__original_layoutSubviews_Imp)(self, _cmd);
}

+ (void)load {
    static dispatch_once_t swizzleLayoutSubviewsToken;
	dispatch_once(&swizzleLayoutSubviewsToken, ^{
		Method m = class_getInstanceMethod([self class], @selector(layoutSubviews));
        __original_layoutSubviews_Imp = method_setImplementation(m, (IMP)dv_layoutSubviews_Imp);
	});
}

@end
