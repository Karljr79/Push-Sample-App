//
//  PaymentViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/2/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import "PaymentViewController.h"
#import "SwipeViewController.h"
#import "ManualViewController.h"

#import <PayPalHereSDK/PayPalHereSDK.h>

#define kBURGERS		@"Burgers"
#define kFRIES          @"Fries"
#define kSHAKES         @"Shakes"
#define kPIES           @"Pies"
#define kPRICE			@"Price"
#define kQUANTITY		@"Quantity"

@interface PaymentViewController ()

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
    // Do any additional setup after loading the view.
    NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:self.invoiceToPay.totalAmount.stringValue];
    self.txtTotalAmount.text = total.stringValue;
    self.imageStatus.image = [self imageForStatus:self.invoiceToPay.status];
    
    if ([self.invoiceToPay.status  isEqual: @"Paid"])
    {
        self.txtTotalLabel.text = @"Total Paid";
        self.buttonManual.hidden = YES;
        self.buttonSwipe.hidden = YES;
        self.buttonRefund.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];
    
    NSArray *itemList = @[kBURGERS, kFRIES, kSHAKES, kPIES];
    
    for (NSString *itemName in itemList)
    {
        NSMutableDictionary *items = [self.invoiceToPay.shoppingCart valueForKey:itemName];
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

- (IBAction)btnManualEntry:(id)sender {
    ManualViewController *manualVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ManualVC"];
    manualVC.amountToPay = self.invoiceToPay.totalAmount;
    [self.navigationController pushViewController:manualVC animated:YES];
}

- (IBAction)btnSwipeEntry:(id)sender {
    SwipeViewController *swipeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SwipeVC"];
    swipeVC.amountToPay = self.invoiceToPay.totalAmount;
    [self.navigationController pushViewController:swipeVC animated:YES];
}

- (IBAction)btnRefund:(id)sender {
}

- (UIImage *)imageForStatus:(NSString*)status
{
    if ([status isEqualToString:@"Paid"]){
        return [UIImage imageNamed:@"Paid"];
    }
    else if ([status isEqualToString:@"UnPaid"]){
        return [UIImage imageNamed:@"UnPaid"];
    }
    return nil;
}



@end
