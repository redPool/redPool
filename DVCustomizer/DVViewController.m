//
//  DVViewController.m
//  DVCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/7/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import "DVViewController.h"

@interface DVViewController () <DVSettingsViewControllerDelegate>

@property (nonatomic, assign) BOOL alreadyDisplayedDVCustomizer;

@end

@implementation DVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    
    if(!self.alreadyDisplayedDVCustomizer) {
        self.alreadyDisplayedDVCustomizer = YES;
        
        UIViewController *settings = [DVSettingsViewController settingsViewController];
        if(!settings)
            return;
        ((DVSettingsViewController *)settings).delegate = self;
        settings.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didPressedDoneButton)];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settings];
        [[[[[UIApplication sharedApplication] windows] lastObject] rootViewController] presentViewController:nav animated:YES completion:nil];
    }
}

- (void)didPressedDoneButton {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard {
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}

@end
