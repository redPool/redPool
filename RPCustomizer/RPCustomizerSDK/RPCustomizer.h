//
//  RPCustomizer.h
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSettingsViewController.h"
#import "UIView+RPView.h"


@interface RPCustomizer : NSObject

+ (void)setSkinName:(NSString *)name andRPValuesIndex:(NSInteger)index;
+ (void)presentSettingsAtItinialization:(BOOL)presentAtInitialization;
+ (RPCustomizer *)sharedManager;
- (void)customizeComponent:(UIView *)component;
- (NSDictionary *)getSkin;
- (void)setSkinDictionary:(NSDictionary *)skin;
- (void)reloadCustomization;

@end
