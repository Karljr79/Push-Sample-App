//
//  PaymentViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/2/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "PaymentViewController.h"
#import "SwipeViewController.h"
#import "ManualViewController.h"
#import "AppDelegate.h"

#import <PayPalHereSDK/PayPalHereSDK.h>

#define kBURGERS		@"Burgers"
#define kFRIES          @"Fries"
#define kSHAKES         @"Shakes"
#define kPIES           @"Pies"
#define kPRICE			@"Price"
#define kQUANTITY		@"Quantity"

@interface PaymentViewController ()

@property (strong, nonatomic) Invoice *currInvoice;

@end

@implementation PaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //load the invoice in question
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Add the record into an array so that we can issue a refund later.
    Invoice* myInvoice = (Invoice *)[appDelegate._invoices objectAtIndex:self.invoiceID.integerValue];
    self.currInvoice = myInvoice;
    
    // Do any additional setup after loading the view.
    self.txtTotalAmount.text = self.currInvoice.getTotalString;
    
    [self refreshView];
}

//add to the paypal invoice upon loading the page
- (void)viewWillAppear:(BOOL)animated
{
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];
    
    [tm beginPayment];
    
    NSArray *itemList = @[kBURGERS, kFRIES, kSHAKES, kPIES];
    
    for (NSString *itemName in itemList)
    {
        NSMutableDictionary *items = [self.currInvoice.shoppingCart valueForKey:itemName];
        NSDecimalNumber *quantity = [items valueForKey:kQUANTITY];
        NSDecimalNumber *costEach = [items valueForKey:kPRICE];
        
        [tm.currentInvoice addItemWithId:itemName name:itemName quantity:quantity unitPrice:costEach taxRate:nil taxRateName:nil];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnRefund:(id)sender
{
    [self handleRefund:self.currInvoice.transactionResponse.record];
}

-(void)handleRefund:(PPHTransactionRecord *)txRecord
{
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];
    [tm beginRefund:txRecord forAmount:txRecord.invoice.totalAmount completionHandler:^(PPHPaymentResponse * response)
    {
        if(response.error)
        {
            [self showAlertWithTitle:@"Refund Error" andMessage:response.error.description];
        } else
        {
            [self showAlertWithTitle:@"Refund Successful" andMessage:@"Your transaction amount was successfully refunded."];
            
            self.currInvoice.status = @"Refund";
            
            [self refreshView];
        }

    }];
}

//sets header image based on the current invoice's status
- (UIImage *)imageForStatus:(NSString*)status
{
    if ([status isEqualToString:@"Paid"]){
        return [UIImage imageNamed:@"Paid"];
    }
    else if ([status isEqualToString:@"UnPaid"]){
        return [UIImage imageNamed:@"Unpaid"];
    }
    else if ([status isEqualToString:@"Refund"]){
        return [UIImage imageNamed:@"Refunded"];
    }
    return nil;
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

-(void)refreshView
{
    self.imageStatus.image = [self imageForStatus:self.currInvoice.status];
    
    
    //set up page view, buttons, etc.
    if ([self.currInvoice.status  isEqual: @"Paid"])
    {
        self.txtTotalLabel.text = @"Total Paid";
        self.buttonManual.hidden = YES;
        self.buttonSwipe.hidden = YES;
        self.buttonRefund.hidden = NO;
    }
    else if ([self.currInvoice.status isEqual:@"Refund"])
    {
        self.txtTotalLabel.text = @"Total Refunded";
        self.buttonManual.hidden = YES;
        self.buttonSwipe.hidden = YES;
        self.buttonRefund.hidden = YES;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ManualEntry"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        ManualEntryViewController *manualEntryViewController = [navigationController viewControllers][0];
        manualEntryViewController.invoiceID = self.invoiceID;
        manualEntryViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SwipeEntry"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        SwipeEntryViewController *swipeEntryViewController = [navigationController viewControllers][0];
        swipeEntryViewController.invoiceID = self.invoiceID;
        swipeEntryViewController.delegate = self;
    }
}

#pragma mark - ManualEntryViewControllerDelegate

- (void)manualEntryViewControllerDidCancel:(ManualEntryViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SwipeEntryViewControllerDelegate

- (void)swipeEntryViewControllerDidCancel:(SwipeEntryViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
