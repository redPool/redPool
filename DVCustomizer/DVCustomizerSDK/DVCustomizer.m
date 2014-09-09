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
        NSLog(@"Object DVCustomType: %@", component.dvCustomType);
        dict = [[self.skin objectForKey:NSStringFromClass([component class])] objectAtIndex:[component.dvCustomType integerValue]];
        
        if ([component isKindOfClass:[UIImageView class]]) {
            if ([dict objectForKey:kImageColor]) {
                [((UIImageView *)component) setImage:[((UIImageView *)component).image imageWithColor:[UIColor colorFromHexString:[dict objectForKey:kImageColor]]]];
            }
        }
        
        [self customizeComponent:component withDict:dict];
    }
}

- (void)customizeComponent:(UIView *)component withDict:(NSDictionary *)dict {
    for (NSString *key in [dict allKeys]) {
        if (![key isEqualToString:kItemName]
            && ![key isEqualToString:kImageColor]) {
            
            if ([[dict objectForKey:key] isKindOfClass:[NSString class]]
                && [[key lowercaseString] rangeOfString:kColor].location != NSNotFound) {
                if ([key rangeOfString:kLayer].location != NSNotFound) {
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

- (void)reloadCustomization {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kCustomizationReloadNotification object:self]];
}

#pragma mark Utils

- (void)customizeCALayer:(CALayer *)layer withDictionary:(NSDictionary *)dictionary {

}

@end
