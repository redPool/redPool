//
//  DVComponentEditionViewController.m
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/3/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import "DVComponentEditionViewController.h"
#import "DVColorPickerController.h"

static NSString *cellIdentifier = @"dv_customizer_cell_identifier_comoponent";

@interface DVComponentEditionViewController () <UITableViewDataSource, UITableViewDelegate, DVColorPickerControllerDelegate>

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
    return [self.keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.keys objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.keys objectAtIndex:indexPath.row];
    
    if ([key isEqualToString:@"itemName"]) {
        //call string edition
    } else if ([[key lowercaseString] rangeOfString:@"color"].location != NSNotFound) {
        DVColorPickerController *colorPickerController = [DVColorPickerController new];
        colorPickerController.hexColor = [self.currentComponent objectForKey:key];
        colorPickerController.key = key;
        colorPickerController.delegate = self;
        [self.navigationController pushViewController:colorPickerController animated:YES];
    } else {
        //textfield editor
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

@end
