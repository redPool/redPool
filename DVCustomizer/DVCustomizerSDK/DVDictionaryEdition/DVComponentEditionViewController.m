//
//  DVComponentEditionViewController.m
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/3/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import "DVComponentEditionViewController.h"
#import "DVColorPickerController.h"
#import "DVNumberPickerController.h"

static NSString *cellIdentifier = @"dv_customizer_cell_identifier_comoponent";

@interface DVComponentEditionViewController () <UITableViewDataSource, UITableViewDelegate, DVColorPickerControllerDelegate, DVNumberPickerController>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *keys;

@end

@implementation DVComponentEditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didFinishedEditingComponent)];
    self.navigationItem.leftBarButtonItem = doneButton;
    self.keys = [self.currentComponent allKeys];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.keys count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == [self.keys count]) {
        cell.textLabel.text = @"Add item property";
    } else {
        cell.textLabel.text = [self.keys objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.keys count]) {
        DVNumberPickerController *numberPickerController = [DVNumberPickerController new];
        numberPickerController.placeholderText = @"New item property";
        numberPickerController.key = self.componentIdentifier;
        numberPickerController.delegate = self;
        numberPickerController.textFieldType = DVTextFieldTypeText;
        [self.navigationController pushViewController:numberPickerController animated:YES];
    } else {
        NSString *key = [self.keys objectAtIndex:indexPath.row];
        
        if ([key isEqualToString:@"itemName"]) {
            DVNumberPickerController *numberPickerController = [DVNumberPickerController new];
            numberPickerController.originalText = [self.currentComponent objectForKey:key];
            numberPickerController.key = key;
            numberPickerController.delegate = self;
            numberPickerController.textFieldType = DVTextFieldTypeText;
            [self.navigationController pushViewController:numberPickerController animated:YES];
        } else if ([[key lowercaseString] rangeOfString:@"color"].location != NSNotFound) {
            DVColorPickerController *colorPickerController = [DVColorPickerController new];
            colorPickerController.hexColor = [self.currentComponent objectForKey:key];
            colorPickerController.key = key;
            colorPickerController.delegate = self;
            [self.navigationController pushViewController:colorPickerController animated:YES];
        } else if ([[key lowercaseString] rangeOfString:@"width"].location != NSNotFound
                   || [[key lowercaseString] rangeOfString:@"radius"].location != NSNotFound) {
            DVNumberPickerController *numberPickerController = [DVNumberPickerController new];
            numberPickerController.originalText = [self.currentComponent objectForKey:key];
            numberPickerController.key = key;
            numberPickerController.delegate = self;
            numberPickerController.textFieldType = DVTextFieldTypeFloat;
            [self.navigationController pushViewController:numberPickerController animated:YES];
        }
    }
}

- (void)didFinishedEditingComponent {
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(didFinishedEditingComponent:withIdentifier:)]) {
        [self.delegate didFinishedEditingComponent:self.currentComponent withIdentifier:self.componentIdentifier];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Color picker Delegate

- (void)didFinishedEditingColor:(NSString *)hexNewColor withKey:(NSString *)key {
    NSMutableDictionary *dict = [self.currentComponent mutableCopy];
    [dict setObject:hexNewColor forKey:key];
    self.currentComponent = dict;
}

#pragma makr - Numper picker delegate

- (void)didFinishedEditingValue:(NSString *)string withKey:(NSString *)key {
    if ([key isEqualToString:self.componentIdentifier]) {
        NSMutableDictionary *dict = [self.currentComponent mutableCopy];
        [dict setObject:@"" forKey:string];
        self.currentComponent = dict;
        self.keys = [self.currentComponent allKeys];
    } else {
        NSMutableDictionary *dict = [self.currentComponent mutableCopy];
        [dict setObject:string forKey:key];
        self.currentComponent = dict;
    }
    [self.tableView reloadData];
}

@end
