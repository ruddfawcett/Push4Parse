//
//  SendNotificationViewController.h
//  Push4Parse
//
//  Created by Rex Finn on 6/7/13.
//  Copyright (c) 2013 Trigon, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface SendNotificationViewController : UITableViewController <UITextViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *alertText;

@property (strong, nonatomic) NSDictionary *appInfo;

@property (strong, nonatomic) UITextView *alertComposer;

@property (strong, nonatomic) UISwitch *channelSwitchView;
@property (strong, nonatomic) UISwitch *badgeSwitchView;

@property (strong, nonatomic) UITextField *channelTextField;
@property (strong, nonatomic) UITextField *badgeTextField;

@property (nonatomic) BOOL channelSwitch;
@property (nonatomic) BOOL badgeSwitch;

@end
