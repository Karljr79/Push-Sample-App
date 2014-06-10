//
//  InvoiceDetailViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"

@class InvoiceCreationViewController;

@protocol InvoiceDetailViewControllerDelegate <NSObject>
- (void)invoiceDetailViewControllerDidCancel:(InvoiceCreationViewController *)controller;
- (void)invoiceDetailViewControllerDidSave:(InvoiceCreationViewController *)controller;
@end

@interface InvoiceCreationViewController : UITableViewController

@property (nonatomic, weak) id <InvoiceDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) Invoice* currInvoice;
@property (weak, nonatomic) IBOutlet UILabel *txtBurgerAmt;
@property (weak, nonatomic) IBOutlet UILabel *txtFriesAmt;
@property (weak, nonatomic) IBOutlet UILabel *txtShakesAmt;
@property (weak, nonatomic) IBOutlet UILabel *txtPiesAmt;
@property (weak, nonatomic) IBOutlet UILabel *txtTotalAmount;
- (IBAction)btnBurger:(id)sender;
- (IBAction)btnFries:(id)sender;
- (IBAction)btnPie:(id)sender;
- (IBAction)btnShake:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;


@end
