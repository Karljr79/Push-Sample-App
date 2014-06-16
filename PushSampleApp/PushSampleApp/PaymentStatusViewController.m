//
//  PaymentStatusViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/4/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import "PaymentStatusViewController.h"
#import <PayPalHereSDK/PPHTransactionManager.h>
#import <PayPalHereSDK/PPHTransactionRecord.h>
#import <PayPalHereSDK/PPHError.h>


@interface PaymentStatusViewController ()

@end

@implementation PaymentStatusViewController

@synthesize transactionResponse;
@synthesize invoiceID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIColor *clrGreen = [UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    UIColor *clrRed = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    
    //Handle displaying the status
    if(self.transactionResponse.error == nil) {
        
        //set Actual status text
        self.txtActualStatus.text = @"Payment Successful";
        self.txtActualStatus.textColor = clrGreen;
        
        //handle master invoice record updating
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        Invoice *myInvoice = [appDelegate._invoices objectAtIndex:self.invoiceID.integerValue];
        myInvoice.status = @"Paid";
        //myInvoice.transactionID = self.transactionResponse.record.transactionId;
        
        
        
        if(self.transactionResponse.record.transactionId != nil)
        {
            self.txtStatusDetail.text = [NSString stringWithFormat: @"Transaction Id: %@", myInvoice.transactionResponse.record.transactionId];
        } else
        {
            self.txtStatusDetail.text = [NSString stringWithFormat: @"Invoice Id: %@", myInvoice.transactionResponse.record.transactionId];
        }
    }
    else
    {
        self.txtActualStatus.textColor = clrRed;
        self.txtActualStatus.text = @"Payment Declined";
        self.txtStatusDetail.text = [NSString stringWithFormat: @"Error: %@", self.transactionResponse.error.description];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSendEmail:(id)sender
{
    //check to see if a value was entered
    if (self.txtEmail.text.length < 1 || ![self NSStringIsValidEmail:self.txtEmail.text])
    {
        //Show Alert
        [self showAlertWithTitle:@"Send Receipt" andMessage:@"Please enter a valid e-mail address"];
    }
    else
    {
        [self sendReceiptWithAddress:self.txtEmail.text andIsEmail:YES];
    }
}

- (IBAction)btnSendText:(id)sender
{
    //check to see if a value was entered
    if (10 != self.txtPhoneNumber.text.length)
    {
        //Show Alert
        [self showAlertWithTitle:@"Send Receipt" andMessage:@"Please enter a valid phone number"];
    }
    else
    {
        [self sendReceiptWithAddress:self.txtPhoneNumber.text andIsEmail:NO];
    }
}

- (void)sendReceiptWithAddress:(NSString*)addressToSend andIsEmail:(BOOL)isEmail
{
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];
    PPHReceiptDestination *destination = [[PPHReceiptDestination alloc] init];
    
    destination.destinationAddress = addressToSend;
    
    destination.isEmail = isEmail;
    
    [tm sendReceipt:self.transactionResponse.record toRecipient:destination completionHandler:^(PPHError *error) {
        if(error == nil) {
            [self showAlertWithTitle:@"Receipt Sent" andMessage:@"Please wait to receive the receipt on your device."];
        } else {
            [self showAlertWithTitle:@"Receipt Send Error" andMessage:error.description];
        }
    }];
}

// Check to see if email is valid
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alertView =
    [[UIAlertView alloc]
     initWithTitle:title
     message: message
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
    [alertView show];
}

@end
