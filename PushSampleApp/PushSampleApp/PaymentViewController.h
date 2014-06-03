//
//  PaymentViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/2/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"
#import "ManualEntryViewController.h"

@interface PaymentViewController : UIViewController <ManualEntryViewControllerDelegate>;

@property (nonatomic, weak) Invoice *invoiceToPay;
@property (weak, nonatomic) IBOutlet UIImageView *imageStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtTotalAmount;
@property (weak, nonatomic) IBOutlet UIButton *buttonSwipe;
@property (weak, nonatomic) IBOutlet UIButton *buttonManual;
@property (weak, nonatomic) IBOutlet UIButton *buttonRefund;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalLabel;

- (IBAction)btnManualEntry:(id)sender;
- (IBAction)btnSwipeEntry:(id)sender;
- (IBAction)btnRefund:(id)sender;
- (UIImage *)imageForStatus:(NSString*)status;


@end
