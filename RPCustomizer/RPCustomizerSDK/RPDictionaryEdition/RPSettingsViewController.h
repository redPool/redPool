//
//  RPSettingsViewController.h
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/3/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPSettingsViewControllerDelegate <NSObject>

- (void)didPressedDoneButton;

@end

@interface RPSettingsViewController : UIViewController

@property (nonatomic, assign) id<RPSettingsViewControllerDelegate> delegate;

+ (RPSettingsViewController *)settingsViewController;
+ (void)shouldShowAtInit:(BOOL)shouldShow;
+ (BOOL)shouldShowAtInit;

@end
