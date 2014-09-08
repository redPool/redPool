//
//  DVNumberPickerController.h
//  DVCustomizer
//
//  Created by José Daniel Vásquez Gómez on 9/8/14.
//  Copyright (c) 2014 José Daniel Vásquez Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ENUM(NSInteger, DVTextFieldType) {
    DVTextFieldTypeInteger = 0,
    DVTextFieldTypeFloat,
    DVTextFieldTypeColor,
    DVTextFieldTypeText
};


@protocol DVNumberPickerController <NSObject>

- (void)didFinishedEditingValue:(NSString *)string withKey:(NSString *)key;

@end


@interface DVNumberPickerController : UIViewController

@property (nonatomic, assign) id <DVNumberPickerController>delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, assign) NSInteger textFieldType;
@property (nonatomic, strong) NSString *originalText;
@property (nonatomic, strong) NSString *key;

@end
