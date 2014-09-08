//
//  DVNumberPickerController.m
//  DVCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/8/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import "DVNumberPickerController.h"


@interface DVNumberPickerController () <UITextFieldDelegate>

@end


@implementation DVNumberPickerController

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
        case DVTextFieldTypeInteger:
            [self.textField setKeyboardType:UIKeyboardTypeNumberPad];
            break;
            
        case DVTextFieldTypeFloat:
            [self.textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            break;
            
        case DVTextFieldTypeColor:
            [self.textField setKeyboardType:UIKeyboardTypeDefault];
            break;
            
        default:
            break;
    }
    
    self.textField.text = self.originalText;
    
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
        && [self.delegate respondsToSelector:@selector(didPressedReturnButtonWithAnswer:)]) {
#warning validate input
        [self.delegate didPressedReturnButtonWithAnswer:self.textField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
