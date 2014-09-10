//
//  RPNumberPickerController.m
//  RPCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/8/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import "RPNumberPickerController.h"


@interface RPNumberPickerController () <UITextFieldDelegate>

@end


@implementation RPNumberPickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureTextField {
    [self.textField becomeFirstResponder];
    
    switch (self.textFieldType) {
        case RPTextFieldTypeInteger:
            [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
            break;
            
        case RPTextFieldTypeFloat:
            [self.textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            break;
            
        case RPTextFieldTypeColor:
            [self.textField setKeyboardType:UIKeyboardTypeDefault];
            break;
            
        case RPTextFieldTypeText:
            [self.textField setKeyboardType:UIKeyboardTypeDefault];
            break;
            
        default:
            break;
    }
    
    if (self.originalText) {
        self.textField.text = [NSString stringWithFormat:@"%@", self.originalText];
    }
    
    if (self.placeholderText) {
        self.textField.placeholder = self.placeholderText;
    }
    
    UIToolbar *inputAccessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(inputAccessoryView.frame.size.width - 64.0f, 0.0f, 64.0f, 44.0f)];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [inputAccessoryView addSubview:button];
    [button addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    self.textField.inputAccessoryView = inputAccessoryView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self done];
    return YES;
}

- (void)done {
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(didFinishedEditingValue:withKey:)]) {
#warning validate input
        [self.delegate didFinishedEditingValue:self.textField.text withKey:self.key];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
