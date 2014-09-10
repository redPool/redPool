//
//  RPColorPickerController.m
//  RPCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/7/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import "RPColorPickerController.h"
#import "NSString+RPUtils.h"
#import "UIColor+RPUtils.h"

@interface RPColorPickerController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;
@property (weak, nonatomic) IBOutlet UIView *colorSampleView;

@property (nonatomic, strong) NSString *hexColorPhone;
@property (nonatomic, strong) NSString *hexColorPad;
@property (nonatomic, strong) UIColor *currentColor;

@end

@implementation RPColorPickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didFinishedEditingColor)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [self configureColorInitialization];
    [self reloadColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureColorInitialization {
    self.hexColorPad = [self.hexColor getStringForPad];
    self.hexColorPhone = [self.hexColor getStringForPhone];
    self.currentColor = [UIColor colorFromHexString:self.hexColorPhone];
}

- (void)reloadColor {
    [self.colorSampleView setBackgroundColor:self.currentColor];
    self.colorTextField.text = (self.segmentedControl.selectedSegmentIndex == 0)? self.hexColorPhone : self.hexColorPad;
    self.redSlider.value = [self.currentColor red];
    self.greenSlider.value = [self.currentColor green];
    self.blueSlider.value = [self.currentColor blue];
    self.alphaSlider.value = [self.currentColor alpha];
}

- (IBAction)didChangedSegmentedControl:(id)sender {
    self.currentColor = (self.segmentedControl.selectedSegmentIndex == 0)? [UIColor colorFromHexString:self.hexColorPhone] : [UIColor colorFromHexString:self.hexColorPad];
    [self reloadColor];
}

- (IBAction)didChangedRedValue:(id)sender {
    [self didChangeValueForSlider:sender];
}

- (IBAction)didChangedGreenValue:(id)sender {
    [self didChangeValueForSlider:sender];
}

- (IBAction)didChangedBlueValue:(id)sender {
    [self didChangeValueForSlider:sender];
}

- (IBAction)didChangedAlphaValue:(id)sender {
    [self didChangeValueForSlider:sender];
}

- (void)didChangeValueForSlider:(id)sender {
    self.currentColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:self.alphaSlider.value];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.hexColorPhone = [UIColor hexStringFromColor:self.currentColor];
    } else {
        self.hexColorPad = [UIColor hexStringFromColor:self.currentColor];
    }
    
    [self reloadColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.currentColor = [UIColor colorFromHexString:textField.text];
    [self reloadColor];
    [self hideKeyboard];
    return YES;
}

- (void)hideKeyboard {
    [self.colorTextField resignFirstResponder];
}

- (void)didFinishedEditingColor {
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(didFinishedEditingColor:withKey:)]) {
        [self.delegate didFinishedEditingColor:[NSString stringWithFormat:@"%@:%@", self.hexColorPhone, self.hexColorPad] withKey:self.key];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
