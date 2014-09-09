//
//  DVViewController.m
//  DVCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/7/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import "DVViewController.h"
#import "DVNumberPickerController.h"

@interface DVViewController () <DVSettingsViewControllerDelegate, DVNumberPickerController>

@property (weak, nonatomic) IBOutlet UIButton *editDictionaryButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *componentsArray;

@property (nonatomic, strong) NSMutableArray *gesturesArray;

@property (nonatomic, assign) BOOL alreadyDisplayedDVCustomizer;
@property (nonatomic, assign) BOOL isEditingComponentsTypes;

@property (nonatomic, strong) UIView *currentEditedView;

@end

@implementation DVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit Component Type" style:UIBarButtonItemStyleDone target:self action:@selector(didPressedEditComponentTypeButton)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.gesturesArray = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];

    if (!self.alreadyDisplayedDVCustomizer) {
        [self showSettings];
        self.alreadyDisplayedDVCustomizer = !self.alreadyDisplayedDVCustomizer;
    }
}

- (void)didPressedDoneButton {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard {
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)showSettings {
    UIViewController *settings = [DVSettingsViewController settingsViewController];
    if(!settings)
        return;
    ((DVSettingsViewController *)settings).delegate = self;
    settings.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didPressedDoneButton)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settings];
    [self.navigationController presentViewController:nav animated:YES completion:nil];

}

- (void)didPressedEditComponentTypeButton {
    self.isEditingComponentsTypes = !self.isEditingComponentsTypes;
    self.navigationItem.rightBarButtonItem.title = (self.isEditingComponentsTypes)? @"Finish Edition" : @"Edit Component Type";
    
    for (int i = 0; i < [self.componentsArray count]; i++) {
        
        UIView *view = [self.componentsArray objectAtIndex:i];
        
        if (self.isEditingComponentsTypes) {
            UITapGestureRecognizer *componentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressedComponentForEditType:)];
            [self.gesturesArray addObject:componentTapGesture];
            [view addGestureRecognizer:componentTapGesture];
            [view setUserInteractionEnabled:YES];
            
        } else {
            [view removeGestureRecognizer:[self.gesturesArray objectAtIndex:i]];
        }
    }
}

- (void)didPressedComponentForEditType:(id)sender {
    DVNumberPickerController *picker = [DVNumberPickerController new];
    picker.delegate = self;
    picker.textFieldType = DVTextFieldTypeInteger;
    self.currentEditedView = ((UITapGestureRecognizer *)sender).view;
    picker.originalText = self.currentEditedView.dvCustomType;

    [self.navigationController pushViewController:picker animated:YES];
}

- (void)didFinishedEditingValue:(NSString *)string withKey:(NSString *)key {
    self.currentEditedView.dvCustomType = string;
    [[DVCustomizer sharedManager] reloadCustomization];
}
- (IBAction)didPressedEditDictionaryButton:(id)sender {
    [self showSettings];
}

@end
