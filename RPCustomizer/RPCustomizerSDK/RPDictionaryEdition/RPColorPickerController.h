//
//  RPColorPickerController.h
//  RPCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/7/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPColorPickerControllerDelegate <NSObject>

- (void)didFinishedEditingColor:(NSString *)hexNewColor withKey:(NSString *)key;

@end

@interface RPColorPickerController : UIViewController

@property (nonatomic, assign) id <RPColorPickerControllerDelegate>delegate;
@property (nonatomic, strong) NSString *hexColor;
@property (nonatomic, strong) NSString *key;

@end
