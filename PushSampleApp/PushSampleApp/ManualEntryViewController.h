//
//  ManualEntryViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/3/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Invoice.h"

@class ManualEntryViewController;

@protocol ManualEntryViewControllerDelegate <NSObject>
- (void)manualEntryViewControllerDidCancel:(ManualEntryViewController *)controller;
@end

@interface ManualEntryViewController : UITableViewController <UITextFieldDelegate, PPHTransactionControllerDelegate>

@property (nonatomic, weak) id <ManualEntryViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtCCNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtCCMonth;
@property (weak, nonatomic) IBOutlet UITextField *txtCCYear;
@property (weak, nonatomic) IBOutlet UITextField *txtCVV2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinProcessing;
@property (weak, nonatomic) IBOutlet UIImageView *imgCardType;
@property (weak, nonatomic) NSNumber *invoiceID;

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)imageForCardType;
- (void)completeTransaction;
- (BOOL)checkExpDateWithMonth:(NSString *)expMonth andYear:(NSString *)expYear;
- (BOOL)checkCCNumberValidity:(NSString *)cardNumber;
- (BOOL)checkCVV2Validity:(NSString *)cvv2;
- (IBAction)cancel:(id)sender;
- (IBAction)btnPayment:(id)sender;
- (NSString*) getCurrentYear;


@end
