//
//  MyAppsViewController.m
//  Push4Parse
//
//  Created by Rudd Fawcett on 6/5/13.
//  Copyright (c) 2013 Trigon, LLC. All rights reserved.
//

#import "MyAppsViewController.h"

@interface MyAppsViewController () 

@end

@implementation MyAppsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addApplication:)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.backBarButtonItem = backButton;
    
    self.title = @"My Apps";
    
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MyApplications.plist"];
    
    self.userApplications = [NSMutableArray arrayWithContentsOfFile:plistPath];

    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tableView.editing = NO;
    
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem.title = @"Edit";
}

- (IBAction)addApplication:(id)sender {
    AddApplicationViewController *vc = [[AddApplicationViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userApplications.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.userApplications.count != 0) {
        return @"Push4Parse, Version 1.1";
    }
    else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    NSDictionary *application = [self.userApplications objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [application objectForKey:@"AppName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Added on %@",[application objectForKey:@"DateCreated"]];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.tintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *newPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MyApplications.plist"];
        
        [self.userApplications removeObjectAtIndex:indexPath.row];
        
        [self.userApplications writeToFile:newPath atomically:YES];
        
        if ([self.userApplications  writeToFile:newPath atomically:YES]) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (self.userApplications.count == 0) {
                self.tableView.editing = NO;
                
                self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
                self.navigationItem.leftBarButtonItem.title = @"Edit";
                
                [self.tableView reloadData];
            }
        }
        else {
            NSLog(@"Error...");
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    EditInfoViewController *vc = [[EditInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    NSDictionary *appDict = [self.userApplications objectAtIndex:indexPath.row];
    [vc setApplicationAtIndex:appDict];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SendNotificationViewController *sendNotification = [[SendNotificationViewController alloc] initWithStyle:UITableViewStyleGrouped];

    NSDictionary *appInfo = [[NSDictionary alloc] initWithDictionary:[self.userApplications objectAtIndex:[[self.tableView indexPathForSelectedRow] row]]];
    [sendNotification setAppInfo:appInfo];
    
    [[self navigationController] pushViewController:sendNotification animated:YES];
}

@end
