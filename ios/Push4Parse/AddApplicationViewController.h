//
//  AddApplicationViewController.h
//  Push4Parse
//
//  Created by Rudd Fawcett on 6/5/13.
//  Copyright (c) 2013 Trigon, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddApplicationViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *applicationTitle;
@property (strong, nonatomic) UITextField *apiKey;
@property (strong, nonatomic) UITextField *appID;

@end
