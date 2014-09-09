//
//  DVSettingsViewController.h
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/3/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DVSettingsViewControllerDelegate <NSObject>

- (void)didPressedDoneButton;

@end

@interface DVSettingsViewController : UIViewController

@property (nonatomic, assign) id<DVSettingsViewControllerDelegate> delegate;

+ (DVSettingsViewController *)settingsViewController;
+ (void)shouldShowAtInit:(BOOL)shouldShow;
+ (BOOL)shouldShowAtInit;

@end
