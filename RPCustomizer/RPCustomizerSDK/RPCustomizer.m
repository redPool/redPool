//
//  RPCustomizer.m
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

#import "RPCustomizer.h"
#import "UIColor+RPUtils.h"
#import "UIImage+RPUtils.h"
#import "RPConstants.h"

static RPCustomizer *shared;
static NSString *skinName;
static NSInteger rpValuesIndex;
static BOOL presentAtInit;

@interface RPCustomizer()

@property (nonatomic, strong) NSDictionary *skin;
@property (nonatomic, strong) RPSettingsViewController *settingsView;

@end

@implementation RPCustomizer

+ (void)setSkinName:(NSString *)name andRPValuesIndex:(NSInteger)index {
    skinName = name;
    rpValuesIndex = index;
}

+ (void)presentSettingsAtItinialization:(BOOL)presentAtInitialization {
    presentAtInit = presentAtInitialization;
}

+ (RPCustomizer *)sharedManager {
    if (!shared
        && skinName
        && ![skinName isEqualToString:@""]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          skinName ofType:@"plist"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        shared = [[RPCustomizer alloc] initWithDictionary:dictionary];
    }
    
    return shared;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.skin = dictionary;
        [RPSettingsViewController shouldShowAtInit:presentAtInit];
    }
    
    return self;
}

- (void)customizeComponent:(UIView *)component {
    NSDictionary *dict = [NSDictionary new];
    
    if ([NSStringFromClass([component class]) rangeOfString:@"UINavigationBar"].location != NSNotFound) {
        [self addObserverToComponent:component];
        component = component.superview;
    }
    
    if (component.rpCustomType && !component.rpAlreadyCustomized) {
        [self addObserverToComponent:component];
        
        dict = [[self.skin objectForKey:NSStringFromClass([component class])] objectAtIndex:[component.rpCustomType integerValue]];
        
        if ([component isKindOfClass:[UIImageView class]]) {
            if ([dict objectForKey:kImageColor]) {
                [((UIImageView *)component) setImage:[((UIImageView *)component).image imageWithColor:[UIColor colorFromHexString:[self getProperValueWithDict:dict andKey:kImageColor]]]];
            }
        }
        
        [self customizeComponent:component withDict:dict];
        component.rpAlreadyCustomized = YES;
        
        if (component.subviews && [component.subviews count] > 0 ) {
            for (UIView *view in component.subviews) {
                [self customizeComponent:view];
            }
        }
    }
}

- (void)customizeComponent:(UIView *)component withDict:(NSDictionary *)dict {
    for (NSString *key in [dict allKeys]) {
        if (![key isEqualToString:kItemName]
            && ![key isEqualToString:kImageColor]) {
            
            id value = [self getProperValueWithDict:dict andKey:key];
            
            if ([component isKindOfClass:[UIButton class]]
                && [value isKindOfClass:[NSDictionary class]]) {
                [self customizeControl:(UIControl *)component withDict:dict key:key andState:[self getUIControlStateFromString:key]];
            } else if ([value isKindOfClass:[NSString class]]
                && [[key lowercaseString] rangeOfString:kColor].location != NSNotFound) {
                if ([key rangeOfString:kLayer].location != NSNotFound) {
                    [component setValue:(id)[UIColor colorFromHexString:value].CGColor forKeyPath:key];
                } else {
                    [component setValue:[UIColor colorFromHexString:value] forKeyPath:key];
                }
            } else if ([value respondsToSelector:@selector(intValue)]) {
                [component setValue:@([value floatValue]) forKeyPath:key];
            }
        }
    }
}

- (void)customizeControl:(UIControl *)control withDict:(NSDictionary *)dict key:(NSString *)key andState:(NSInteger)state {

    NSDictionary *btnDict = [dict objectForKey:key];
    
    for (NSString *key in [btnDict allKeys]) {
        if ([control isKindOfClass:[UIButton class]]) {
            if ([key isEqualToString:kBackgroundImageColor]) {
                UIView *colorView = [[UIView alloc] initWithFrame:control.frame];
                colorView.backgroundColor = [UIColor colorFromHexString:[self getProperValueWithDict:btnDict andKey:kBackgroundImageColor]];
                
                if ([dict objectForKey:kLayerDotCornerRadius]) {
                    [colorView.layer setCornerRadius:[[self getProperValueWithDict:dict andKey:kLayerDotCornerRadius] floatValue]];
                }
                
                UIGraphicsBeginImageContext(colorView.bounds.size);
                [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
                
                UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [((UIButton *)control) setBackgroundImage:colorImage forState:state];
            } else if ([key isEqualToString:kTextColor]) {
                [((UIButton *)control) setTitleColor:[UIColor colorFromHexString:[self getProperValueWithDict:btnDict andKey:kTextColor]] forState:state];
            } else if ([key isEqualToString:kText]) {
                [((UIButton *)control) setTitle:[self getProperValueWithDict:btnDict andKey:kText] forState:state];
            }
        }
    }
}

//this method detemines if it must return the dictionary value or the RPValue
- (id)getProperValueWithDict:(NSDictionary *)dict andKey:(NSString *)key {
    if ([[dict objectForKey:key] isKindOfClass:[NSString class]]
        && [[dict objectForKey:key] rangeOfString:kRPValueIdentifier].location != NSNotFound) {
        return [[[self.skin objectForKey:kRPValuesKey] objectAtIndex:rpValuesIndex] objectForKey:[dict objectForKey:key]];
    } else {
        return [dict objectForKey:key];
    }
}

- (NSDictionary *)getSkin {
    return self.skin;
}

- (void)setSkinDictionary:(NSDictionary *)skin {
    self.skin = skin;
}

- (void)setSkinIndex:(NSInteger)index {
    rpValuesIndex = index;
}

- (void)reloadCustomization {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kRPCustomizationDictionaryChangedNotification object:self]];
}

- (void)addObserverToComponent:(UIView *)component {
    if ([RPSettingsViewController shouldShowAtInit] && !component.rpAlreadyAddedObserver) {
        component.rpAlreadyAddedObserver = YES;
        
        // We need to get a hold of the notification observer to avoid leaking memory.
        __weak typeof(component)weakSelf = component;
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kRPCustomizationDictionaryChangedNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          __strong __typeof(weakSelf)strongSelf = weakSelf;
                                                          if (strongSelf) {
                                                              [((UIView *)strongSelf) setNeedsDisplay];
                                                              [((UIView *)strongSelf).superview setNeedsDisplay];
                                                              ((UIView *)strongSelf).rpAlreadyCustomized = NO;

//
                                                            //Check if the object reponds to `layoutSubviews`
															  if ([strongSelf respondsToSelector:@selector(layoutSubviews)]) {
																  [strongSelf layoutSubviews];
															  } else {
																  // If self doesn't responds to `layoutSubviews`
																  // we need to go up until a parent implements it or no more
																  // to go.
																  id superview = [strongSelf superview];
																  while (superview) {
																	  if ([superview respondsToSelector:@selector(layoutSubviews)]) {
																		  [superview layoutSubviews];
																		  
																		  break;
																	  } else {
																		  superview = [superview superview];
																	  }
																  }
															  }
                                                          }
                                                      }];
    }

}

- (NSInteger)getUIControlStateFromString:(NSString *)name {
    NSInteger state = 0;
    
    if ([[name lowercaseString] isEqualToString:kNormalControlState]) {
        state = UIControlStateNormal;
    } else if ([[name lowercaseString] isEqualToString:kHighlightedControlState]) {
        state = UIControlStateHighlighted;
    } else if ([[name lowercaseString] isEqualToString:kSelectedControlState]) {
        state = UIControlStateSelected;
    } else if ([[name lowercaseString] isEqualToString:kDisabledControlState]) {
        state = UIControlStateDisabled;
    }
    
    return state;
}

@end
