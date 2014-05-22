//
//  MyAppsViewController.h
//  Push4Parse
//
//  Created by Rudd Fawcett on 6/5/13.
//  Copyright (c) 2013 Trigon, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfoViewController.h"
#import "AddApplicationViewController.h"
#import "SendNotificationViewController.h"

@interface MyAppsViewController : UITableViewController <UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addApplication;

@property (strong, nonatomic) NSMutableArray *userApplications;

@property (strong, nonatomic) NSArray *searchResults;

@end
