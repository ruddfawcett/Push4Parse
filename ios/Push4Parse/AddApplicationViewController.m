//
//  AddApplicationViewController.m
//  Push4Parse
//
//  Created by Rex Finn on 6/5/13.
//  Copyright (c) 2013 Trigon, LLC. All rights reserved.
//

#import "AddApplicationViewController.h"

@interface AddApplicationViewController ()

@end

@implementation AddApplicationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddition)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveApplicationInformation)];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.title = @"New Application";
}

- (void)cancelAddition {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.applicationTitle becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.applicationTitle) {
        [self.apiKey becomeFirstResponder];
    }
    else if (textField == self.apiKey) {
        [self.appID becomeFirstResponder];
    }
    else {
        [self.view endEditing:YES];
        [self saveApplicationInformation];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (aTextField == self.applicationTitle) {
        self.title = [aTextField.text stringByReplacingCharactersInRange:range withString:string];
    }
    return YES;
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Your information is only stored locally.";
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.applicationTitle) {
        self.title = @"New Application";
    }
    return YES;
}

- (void)saveApplicationInformation {
    if (self.applicationTitle.text.length == 0 || self.apiKey.text.length == 0 || self.appID.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please fill in all fields!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    else {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM d, y";
        
        NSString *dateAdded = [dateFormatter stringFromDate:[NSDate date]];
        
        NSDictionary *information = [NSDictionary dictionaryWithObjectsAndKeys:self.applicationTitle.text, @"AppName", self.apiKey.text, @"AppAPI", self.appID.text, @"AppID", dateAdded, @"DateCreated", nil];
        
        NSString *plistPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"MyApplications.plist"];
        NSMutableArray *plistData = [NSMutableArray arrayWithContentsOfFile:plistPath];
        
        [plistData addObject:information];
        
        [plistData writeToFile:plistPath atomically:YES];
        
        if ([plistData writeToFile:plistPath atomically:YES]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Unable to save data!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.tintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        self.applicationTitle = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, cell.bounds.size.width-40, 21)];
        self.applicationTitle.font = [UIFont boldSystemFontOfSize:17.0];
        self.applicationTitle.textColor = [UIColor blackColor];
        self.applicationTitle.placeholder = @"Application Name";
        self.applicationTitle.keyboardType = UIKeyboardTypeDefault;
        self.applicationTitle.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.applicationTitle.returnKeyType = UIReturnKeyNext;
        self.applicationTitle.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.applicationTitle.autocorrectionType = UITextAutocorrectionTypeNo;
        self.applicationTitle.textAlignment = NSTextAlignmentLeft;
        self.applicationTitle.delegate = self;
        self.applicationTitle.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.applicationTitle.enabled = YES;
        
        cell.accessoryView = self.applicationTitle;
    }
    else if (indexPath.row == 1) {
        self.apiKey = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, cell.bounds.size.width-40, 21)];
        self.apiKey.font = [UIFont boldSystemFontOfSize:17.0];
        self.apiKey.textColor = [UIColor blackColor];
        self.apiKey.placeholder = @"Application REST API Key";
        self.apiKey.keyboardType = UIKeyboardTypeDefault;
        self.apiKey.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.apiKey.returnKeyType = UIReturnKeyNext;
        self.apiKey.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.apiKey.autocorrectionType = UITextAutocorrectionTypeNo;
        self.apiKey.textAlignment = NSTextAlignmentLeft;
        self.apiKey.delegate = self;
        self.apiKey.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.apiKey.enabled = YES;
        
        cell.accessoryView = self.apiKey;
    }
    else if (indexPath.row == 2) {
        self.appID = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, cell.bounds.size.width-40, 21)];
        self.appID.font = [UIFont boldSystemFontOfSize:17.0];
        self.appID.textColor = [UIColor blackColor];
        self.appID.placeholder = @"Application ID";
        self.appID.keyboardType = UIKeyboardTypeDefault;
        self.appID.keyboardAppearance = UIKeyboardAppearanceAlert;
        self.appID.returnKeyType = UIReturnKeyDone;
        self.appID.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.appID.autocorrectionType = UITextAutocorrectionTypeNo;
        self.appID.textAlignment = NSTextAlignmentLeft;
        self.appID.delegate = self;
        self.appID.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.appID.enabled = YES;
        
        cell.accessoryView = self.appID;
    }
    
    return cell;
}

@end
