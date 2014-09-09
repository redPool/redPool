//
//  DVComponentEditionViewController.h
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/3/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DVComponentEditionViewControllerDelegate <NSObject>

- (void)didFinishedEditingComponent:(NSDictionary *)component withIdentifier:(NSString *)identifier;

@end

@interface DVComponentEditionViewController : UIViewController

@property (nonatomic, assign) id <DVComponentEditionViewControllerDelegate>delegate;
@property (nonatomic, strong) NSDictionary *currentComponent;
@property (nonatomic, strong) NSString *componentIdentifier;

@end
