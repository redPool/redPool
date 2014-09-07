//
//  DVComponentEditionViewController.m
//  Timetracker iOS
//
//  Created by José Daniel Vásquez Gómez on 9/3/14.
//  Copyright (c) 2014 Log(n). All rights reserved.
//

#import "DVComponentEditionViewController.h"

static NSString *cellIdentifier = @"dv_customizer_cell_identifier_comoponent";

@interface DVComponentEditionViewController () <UITableViewDataSource, UITableViewDelegate>

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
        //color picker
    } else {
        //textfield editor
    }
}


@end
