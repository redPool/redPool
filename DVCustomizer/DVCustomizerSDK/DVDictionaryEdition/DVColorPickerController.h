//
//  DVColorPickerController.h
//  DVCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/7/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DVColorPickerControllerDelegate <NSObject>

- (void)didFinishedEditingColor:(NSString *)hexNewColor withKey:(NSString *)key;

@end

@interface DVColorPickerController : UIViewController

@property (nonatomic, assign) id <DVColorPickerControllerDelegate>delegate;
@property (nonatomic, strong) NSString *hexColor;
@property (nonatomic, strong) NSString *key;

@end
