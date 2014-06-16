//
//  PaymentStatusViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/4/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayPalHereSDK/PPHTransactionManager.h>
#import "AppDelegate.h"
#import "Invoice.h"

@class PPHTransactionResponse;
@interface PaymentStatusViewController : UITableViewController

@property (strong, nonatomic) PPHTransactionResponse *transactionResponse;

@property (weak, nonatomic) IBOutlet UILabel *txtActualStatus;
@property (weak, nonatomic) IBOutlet UILabel *txtStatusDetail;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) NSNumber *invoiceID;

- (IBAction)btnSendEmail:(id)sender;
- (IBAction)btnSendText:(id)sender;
- (BOOL)NSStringIsValidEmail:(NSString *)checkString;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)sendReceiptWithAddress:(NSString*)destination andIsEmail:(BOOL)isEmail;

@end
