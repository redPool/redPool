//
//  RPSettingsViewController.m
//  RedPool Demo App
//
//  Created by José Daniel Vásquez Gómez on 9/3/14.
//  Copyright (c) 2014 RedPool. All rights reserved.
//

#import "RPSettingsViewController.h"
#import "RPComponentEditionViewController.h"
#import "RPNumberPickerController.h"
#import "RPCustomizer.h"
#import "RPConstants.h"


static RPSettingsViewController *shared;
static BOOL shouldShowAtInit;
static NSString *cellIdentifier = @"dv_customizer_cell_identifier";

@interface RPSettingsViewController () <UITableViewDataSource, UITableViewDelegate, RPComponentEditionViewControllerDelegate, RPNumberPickerController>

@property (nonatomic, strong) NSDictionary *dictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSDictionary *currentComponent;

@end

@implementation RPSettingsViewController

+ (RPSettingsViewController *)settingsViewController {
    if (!shared && shouldShowAtInit) {
        shared = [[RPSettingsViewController alloc] init];
        shared.dictionary = [[RPCustomizer sharedManager] getSkin];
        shared.keys = [shared.dictionary allKeys];
    }
    
    return shared;
}

+ (void)shouldShowAtInit:(BOOL)shouldShow {
    shouldShowAtInit = shouldShow;
}

+ (BOOL)shouldShowAtInit {
    return shouldShowAtInit;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"RPCustomizerSettings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.keys count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.keys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dictionary objectForKey:[self.keys objectAtIndex:section]] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == [((NSArray *)[self.dictionary objectForKey:[self.keys objectAtIndex:indexPath.section]]) count]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Add %@ Component", [self.keys objectAtIndex:indexPath.section]];
    } else {
        NSDictionary *item = [((NSArray *)[self.dictionary objectForKey:[self.keys objectAtIndex:indexPath.section]]) objectAtIndex:indexPath.row];
        cell.textLabel.text = [item objectForKey:kItemName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [((NSArray *)[self.dictionary objectForKey:[self.keys objectAtIndex:indexPath.section]]) count]) {
        RPNumberPickerController *numberPickerController = [RPNumberPickerController new];
        numberPickerController.placeholderText = @"Component item name";
        numberPickerController.key = [self.keys objectAtIndex:indexPath.section];
        numberPickerController.delegate = self;
        numberPickerController.textFieldType = RPTextFieldTypeText;
        [self.navigationController pushViewController:numberPickerController animated:YES];
    } else {
        NSDictionary *itemDict = [((NSArray *)[self.dictionary objectForKey:[self.keys objectAtIndex:indexPath.section]]) objectAtIndex:indexPath.row];
        self.currentComponent = itemDict;
        RPComponentEditionViewController *componentEditionController = [[RPComponentEditionViewController alloc]init];
        componentEditionController.currentComponent = self.currentComponent;
        componentEditionController.componentIdentifier = [NSString stringWithFormat:@"%@:%d", [self tableView:tableView titleForHeaderInSection:indexPath.section], indexPath.row];
        componentEditionController.delegate = self;
        [self.navigationController pushViewController:componentEditionController animated:YES];
    }
}

- (IBAction)didPressedDoneButton:(id)sender {    
    [[RPCustomizer sharedManager]setSkinDictionary:self.dictionary];
    [[RPCustomizer sharedManager] reloadCustomization];
    
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(didPressedDoneButton)]) {
        [self.delegate didPressedDoneButton];
    }
}

#pragma mark - Component edition delegate

- (void)didFinishedEditingComponent:(NSDictionary *)component withIdentifier:(NSString *)identifier {
    NSArray *array = [identifier componentsSeparatedByString:@":"];
    NSMutableDictionary *temp = [self.dictionary mutableCopy];
    NSMutableArray *tempArray = [[temp objectForKey:array[0]] mutableCopy];
    [tempArray removeObjectAtIndex:[array[1] integerValue]];
    [tempArray insertObject:component atIndex:[array[1] integerValue]];
    [temp setObject:tempArray forKey:array[0]];
    self.dictionary = temp;
    [self.tableView reloadData];
}

#pragma mark - RPNumber pirkcer

- (void)didFinishedEditingValue:(NSString *)string withKey:(NSString *)key {
    NSMutableDictionary *temp = [self.dictionary mutableCopy];
    NSMutableDictionary *dict = [@{kItemName:string} mutableCopy];
    NSMutableArray *arrayOfComponents = [[temp objectForKey:key] mutableCopy];
    [temp removeObjectForKey:key];
    [arrayOfComponents addObject:dict];
    [temp setObject:arrayOfComponents forKey:key];
    self.dictionary = temp;
    [self.tableView reloadData];
}

@end
