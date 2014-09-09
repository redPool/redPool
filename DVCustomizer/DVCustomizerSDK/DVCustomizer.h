//
//  DVCustomizer.h
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DVSettingsViewController.h"
#import "UIView+DVView.h"


@interface DVCustomizer : NSObject

+ (void)setSkinName:(NSString *)name;
+ (void)presentSettingsAtItinialization:(BOOL)presentAtInitialization;
+ (DVCustomizer *)sharedManager;
- (void)customizeComponent:(UIView *)component;
- (NSDictionary *)getSkin;
- (void)setSkinDictionary:(NSDictionary *)skin;
- (void)reloadCustomization;

@end
