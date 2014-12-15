//
//  SwipeEntryViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/4/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayPalHereSDK/PPHTransactionManager.h>
#import <PayPalHereSDK/PPHCardReaderDelegate.h>
#import <PayPalHereSDK/PPHTransactionControllerDelegate.h>

@class SwipeEntryViewController;

@protocol SwipeEntryViewControllerDelegate <NSObject>
- (void)swipeEntryViewControllerDidCancel:(SwipeEntryViewController*)controller;
@end

@interface SwipeEntryViewController : UITableViewController <PPHTransactionControllerDelegate, PPHTransactionManagerDelegate, PPHSimpleCardReaderDelegate>

@property (nonatomic, weak) id<SwipeEntryViewControllerDelegate>delegate;
@property (weak, nonatomic) NSNumber *invoiceID;
@property (weak, nonatomic) IBOutlet UILabel *txtReaderStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinReader;

- (IBAction)cancel:(id)sender;
- (void)showPaymentStatusView;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

@end
