//
//  CheckInViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 7/7/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayPalHereSDK/PPHTransactionManager.h>
#import <PayPalHereSDK/PPHLocationWatcher.h>

@class CheckInViewController;

@protocol CheckInViewControllerDelegate <NSObject>
- (void)checkInViewControllerDidCancel:(CheckInViewController *)controller;
@end

@interface CheckInViewController : UITableViewController
<
CheckInViewControllerDelegate,
UITableViewDelegate,
UITableViewDataSource,
PPHLocationWatcherDelegate,
PPHTransactionControllerDelegate
>

@property (nonatomic, weak) id <CheckInViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *checkinLocationId;
@property (weak, nonatomic) NSNumber *invoiceID;

- (IBAction)cancel:(id)sender;

@end