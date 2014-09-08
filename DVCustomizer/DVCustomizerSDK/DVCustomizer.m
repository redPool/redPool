//
//  DVCustomizer.m
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/2/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import "DVCustomizer.h"
#import "UIColor+DVUtils.h"
#import "UIImage+DVUtils.h"

static DVCustomizer *shared;
static NSString *skinName;
static BOOL presentAtInit;

@interface DVCustomizer()

@property (nonatomic, strong) NSDictionary *skin;
@property (nonatomic, strong) DVSettingsViewController *settingsView;

@end

@implementation DVCustomizer

+ (void)setSkinName:(NSString *)name {
    skinName = name;
}

+ (void)presentSettingsAtItinialization:(BOOL)presentAtInitialization {
    presentAtInit = presentAtInitialization;
}

+ (DVCustomizer *)sharedManager {
    if (!shared
        && skinName
        && ![skinName isEqualToString:@""]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          skinName ofType:@"plist"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        shared = [[DVCustomizer alloc] initWithDictionary:dictionary];
    }
    
    return shared;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.skin = dictionary;
        [DVSettingsViewController shouldShowAtInit:presentAtInit];
    }
    
    return self;
}

- (void)customizeComponent:(UIView *)component {
    NSDictionary *dict = [NSDictionary new];
    
    if (component.dvCustomType) {
        if ([component isKindOfClass:[UITextField class]]) {
            NSLog(@"Object DVCustomType: %@", component.dvCustomType);
            dict = [[self.skin objectForKey:@"UITextField"] objectAtIndex:[component.dvCustomType integerValue]];
        } else if ([component isKindOfClass:[UIImageView class]]) {
            dict = [[self.skin objectForKey:@"UIImageView"] objectAtIndex:[component.dvCustomType integerValue]];
            if ([dict objectForKey:@"imageColor"]) {
                [((UIImageView *)component) setImage:[((UIImageView *)component).image imageWithColor:[UIColor colorFromHexString:[dict objectForKey:@"imageColor"]]]];
            }
        } else if ([NSStringFromClass([self class]) hasPrefix:@"UIButton"]) {
            dict = [[self.skin objectForKey:@"UIButton"] objectAtIndex:[component.dvCustomType integerValue]];
        } else if ([component isKindOfClass:[UILabel class]]) {
            dict = [[self.skin objectForKey:@"UILabel"] objectAtIndex:[component.dvCustomType integerValue]];
        } else if ([component isKindOfClass:[UINavigationBar class]]) {
            dict = [[self.skin objectForKey:@"UINavigationBar"] objectAtIndex:[component.dvCustomType integerValue]];
        } else if ([component isKindOfClass:[UITabBar class]]) {
            dict = [[self.skin objectForKey:@"UITabBar"] objectAtIndex:[component.dvCustomType integerValue]];
        } else if ([component isKindOfClass:[UIView class]]) {
            dict = [[self.skin objectForKey:@"UIView"] objectAtIndex:[component.dvCustomType integerValue]];
        }
        
        [self customizeComponent:component withDict:dict];
    }
}

- (void)customizeComponent:(UIView *)component withDict:(NSDictionary *)dict {
    for (NSString *key in [dict allKeys]) {
        if (![key isEqualToString:@"itemName"]
            && ![key isEqualToString:@"imageColor"]) {
            if ([[dict objectForKey:key] isKindOfClass:[NSString class]]) {
                if ([key rangeOfString:@"layer"].location != NSNotFound) {
                    [component setValue:(id)[UIColor colorFromHexString:[dict objectForKey:key]].CGColor forKeyPath:key];
                } else {
                    [component setValue:[UIColor colorFromHexString:[dict objectForKey:key]] forKeyPath:key];
                }
            } else if ([[dict objectForKey:key] respondsToSelector:@selector(intValue)]) {
                [component setValue:@([[dict objectForKey:key] floatValue]) forKeyPath:key];
            }
        }
    }
}

- (NSDictionary *)getSkin {
    return self.skin;
}

- (void)setSkinDictionary:(NSDictionary *)skin {
    self.skin = skin;
}

#pragma mark Utils

- (void)customizeCALayer:(CALayer *)layer withDictionary:(NSDictionary *)dictionary {

}

@end
