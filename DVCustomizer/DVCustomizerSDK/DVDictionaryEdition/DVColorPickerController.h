//
//  DVColorPickerController.h
//  DVCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/7/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVColorPickerController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;
@property (weak, nonatomic) IBOutlet UIView *colorSampleView;
@property (nonatomic, strong) NSString *hexColor;

@end
