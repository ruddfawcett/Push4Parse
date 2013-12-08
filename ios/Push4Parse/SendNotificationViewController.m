//
//  SendNotificationViewController.m
//  Push4Parse
//
//  Created by Rex Finn on 6/7/13.
//  Copyright (c) 2013 Trigon, LLC. All rights reserved.
//

#import "SendNotificationViewController.h"

@interface SendNotificationViewController ()

@end

@implementation SendNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStyleBordered target:self action:@selector(sendNotification:)];
    
    self.navigationItem.rightBarButtonItem = send;
    
    self.title = @"New Notification";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.badgeSwitch = YES;
    
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:dismissKeyboard];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.channelTextField) {
        [self.view endEditing:YES];
    }
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.alertComposer) {
        self.alertText = self.alertComposer.text;
        
        if (self.alertText.length == 1) {
            [self.tableView headerViewForSection:0].textLabel.text = [NSString stringWithFormat:@"COMPOSE ALERT - %lu CHARACTER",(unsigned long)self.alertText.length];
        }
        else if (self.alertText.length == 0) {
            [self.tableView headerViewForSection:0].textLabel.text = [NSString stringWithFormat:@"COMPOSE ALERT"];
        }
        else {
            [self.tableView headerViewForSection:0].textLabel.text = [NSString stringWithFormat:@"COMPOSE ALERT - %lu CHARACTERS",(unsigned long)self.alertText.length];
        }

        [self.tableView headerViewForSection:0].textLabel.font = [UIFont systemFontOfSize:14.0];
        
        if([[textView text] length] > 180){
            self.alertText = self.alertComposer.text;
            
            [self.tableView headerViewForSection:0].textLabel.text = [NSString stringWithFormat:@"COMPOSE ALERT - %lu CHARACTERS",(unsigned long)self.alertText.length];
            [self.tableView headerViewForSection:0].textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        }
        else {
            [self.tableView headerViewForSection:0].textLabel.textColor = [UIColor grayColor];
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.alertText = self.alertComposer.text;
    
    if (textView == self.alertComposer) {
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)actualSend:(NSString*)message withBadge:(NSString*)badge andChannels:(NSString*)channels {
    #warning Make sure to change this - otherwise the app will not work.  See "Building" in README.
    NSLog(@"Make sure to change this - otherwise the app will not work.  See \"Building\" in README.");
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://yourdomain.com/"]];
    
    NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:[self.appInfo objectForKey:@"AppAPI"], @"restAPI", [self.appInfo objectForKey:@"AppID"], @"appID", message, @"alert", channels, @"channels", badge, @"badge", nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [httpClient postPath:@"/Push4Parse/Push4Parse.php" parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        if ([response objectForKey:@"result"]) {
            [SVProgressHUD showSuccessWithStatus:@"Sent!"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [[self navigationController] popToRootViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:[response objectForKey:@"error"]];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error.code == -1009) {
            [SVProgressHUD showErrorWithStatus:@"No Internet!"];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Error!"];
        }
    }];
}

- (IBAction)sendNotification:(id)sender {
    if (self.alertText.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Notification!"];
        
        [self.alertComposer becomeFirstResponder];
    }
    else {
        if (self.channelSwitch && self.badgeSwitch) {
            if (self.channelTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"Channels!"];
                
                [self.channelTextField becomeFirstResponder];
            }
            else if (self.channelTextField.text.length != 0) {
                [self.view endEditing:YES];
                
                [SVProgressHUD showWithStatus:@"Pushing..."];
                
                [self actualSend:self.alertText withBadge:@"Increment" andChannels:self.channelTextField.text];
            }
        }
        else if (self.channelSwitch && !self.badgeSwitch) {
            if (self.channelTextField.text.length == 0 && self.badgeTextField.text.length != 0) {
                [SVProgressHUD showErrorWithStatus:@"Channels!"];
                
                [self.channelTextField becomeFirstResponder];
            }
            else if (self.channelTextField.text.length != 0 && self.badgeTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"Badges!"];
                
                [self.badgeTextField becomeFirstResponder];
            }
            else if (self.channelTextField.text.length == 0 && self.badgeTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"Complete Fields!"];
                
                [self.channelTextField becomeFirstResponder];
            }
            else if (self.channelTextField.text.length != 0 && self.badgeTextField.text.length != 0) {
                [self.view endEditing:YES];
                
                [SVProgressHUD showWithStatus:@"Pushing..."];
                
                [self actualSend:self.alertText withBadge:self.badgeTextField.text andChannels:self.channelTextField.text];
            }
        }
        else if (!self.channelSwitch && self.badgeSwitch) {
            [self.view endEditing:YES];
            
            [SVProgressHUD showWithStatus:@"Pushing..."];
            [self actualSend:self.alertText withBadge:@"Increment" andChannels:@" "];
        }
        else if (!self.channelSwitch && !self.badgeSwitch) {
            if (self.badgeTextField.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"Badges!"];
                
                [self.badgeTextField becomeFirstResponder];
            }
            else if (self.badgeTextField.text.length != 0) {
                [self.view endEditing:YES];
                
                [SVProgressHUD showWithStatus:@"Pushing..."];
                
                [self actualSend:self.alertText withBadge:self.badgeTextField.text andChannels:@" "];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        if (self.channelSwitch) {
            return 2;
        }
        else {
            return 1;
        }
    }
    else if (section == 2) {
        if (!self.badgeSwitch) {
            return 2;
        }
        else {
            return 1;
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"COMPOSE ALERT                                      "];
            break;
        case 1:
            return @"Manage Channels";
            break;
        default:
            return @"Badge Numbers";
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            if (self.channelSwitch) {
                return @"To enter mulitple channels, spererate each channel with a comma.";
            }
            else {
                return @"If you don't use custom channels, you must subscribe to channel on all devices \"\".";
            }
            return @"";
            break;
        case 2:
            if (self.badgeSwitch) {
                return @"Badges are incremented by default.  Turn off to enter a custom badge number.";
            }
            else {
                return @"Enter your desired badge number above.";
            }
            return @"";
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 140;
    }
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.tintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.alertComposer = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 140)];
            
            self.alertComposer.delegate = self;
            self.alertComposer.backgroundColor = [UIColor clearColor];
            [self.alertComposer setEditable:YES];
            self.alertComposer.scrollEnabled = NO;
            self.alertComposer.autocorrectionType = UITextAutocorrectionTypeNo;
            self.alertComposer.delegate = self;
            self.alertComposer.keyboardAppearance = UIKeyboardAppearanceDark;
            self.alertComposer.text = self.alertText;
            self.alertComposer.tintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
            if (self.channelSwitch) {
                self.alertComposer.returnKeyType = UIReturnKeyNext;
            }
            else {
                self.alertComposer.returnKeyType = UIReturnKeyDone;
            }
            self.alertComposer.font = [UIFont systemFontOfSize:15.0];
            
            cell.accessoryView = self.alertComposer;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            self.channelSwitchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            self.channelSwitchView.onTintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
            
            cell.accessoryView = self.channelSwitchView;
            
            if (self.channelSwitch) {
                [self.channelSwitchView setOn:YES animated:NO];
            }
            else {
                [self.channelSwitchView setOn:NO animated:NO];
            }
            
            [self.channelSwitchView addTarget:self action:@selector(channelSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            
            cell.textLabel.text = @"Custom Channel";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 1) {
            self.channelTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, cell.bounds.size.width-40, 21)];
            self.channelTextField.placeholder = @"Channel_1, Channel_2";
            self.channelTextField.font = [UIFont boldSystemFontOfSize:17.0];
            self.channelTextField.returnKeyType = UIReturnKeyDone;
            self.channelTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.channelTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
            self.channelTextField.keyboardAppearance = UIKeyboardAppearanceDark;
            self.channelTextField.delegate = self;
            self.channelTextField.tintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
            
            cell.accessoryView = self.channelTextField;
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            self.badgeSwitchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            self.badgeSwitchView.onTintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
            
            cell.accessoryView = self.badgeSwitchView;
            
            if (self.badgeSwitch) {
                [self.badgeSwitchView setOn:YES animated:NO];
            }
            else {
                [self.badgeSwitchView setOn:NO animated:NO];
            }
            [self.badgeSwitchView addTarget:self action:@selector(badgeSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            
            cell.textLabel.text = @"Increment Badge";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"";
            
            self.badgeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 12, cell.bounds.size.width-40, 21)];
            self.badgeTextField.placeholder = @"5";
            self.badgeTextField.font = [UIFont boldSystemFontOfSize:17.0];
            self.badgeTextField.returnKeyType = UIReturnKeyDone;
            self.badgeTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.badgeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.badgeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
            self.badgeTextField.keyboardAppearance = UIKeyboardAppearanceDark;
            self.badgeTextField.delegate = self;
            self.badgeTextField.tintColor = [UIColor colorWithRed:0.0 green:0.478 blue:1.00 alpha:1.0];
            
            cell.accessoryView = self.badgeTextField;
        }
    }
    return cell;
}

- (void)channelSwitchChanged:(id)sender {
    self.channelSwitchView = sender;
    
    if ([self.channelSwitchView isOn]) {
        self.channelSwitch = YES;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.channelTextField becomeFirstResponder];
    }
    else {
        self.channelSwitch = NO;
        self.channelTextField.text = @"";
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.view endEditing:YES];
    }
}

- (void)badgeSwitchChanged:(id)sender {
    self.badgeSwitchView = sender;
    
    if (![self.badgeSwitchView isOn]) {
        self.badgeSwitch = NO;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.badgeTextField becomeFirstResponder];
    }
    else {
        self.badgeSwitch = YES;
        self.badgeTextField.text = @"";
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.view endEditing:YES];
    }
}

@end
