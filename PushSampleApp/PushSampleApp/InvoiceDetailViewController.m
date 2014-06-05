//
//  InvoiceDetailViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "InvoiceDetailViewController.h"
#import "AppDelegate.h"
#import "Invoice.h"

#define kBURGERS		@"Burgers"
#define kFRIES          @"Fries"
#define kSHAKES         @"Shakes"
#define kPIES           @"Pies"
#define kPRICE			@"Price"
#define kQUANTITY		@"Quantity"

@interface InvoiceDetailViewController ()

@end

@implementation InvoiceDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currInvoice = [[Invoice alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([PayPalHereSDK activeMerchant] == nil)
    {
        [self showAlertWithTitle:@"No Merchant" andMessage:@"Please login before using this page"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self.delegate invoiceDetailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    if ([self getTotalAmount] > 0.00)
    {
        self.currInvoice.totalAmount = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:[self getTotalAmount]];
        self.currInvoice.status = @"UnPaid";
        
        id allInvoices = [(AppDelegate *)[[UIApplication sharedApplication] delegate] _invoices];
        [allInvoices addObject:self.currInvoice];
        
        [self.delegate invoiceDetailViewControllerDidSave:self];
    }
    else
    {
        [self showAlertWithTitle:@"Add Invoice" andMessage:@"Please enter items, total cannot be zero"];
    }
    
    
}

- (IBAction)btnBurger:(id)sender
{
    
    NSMutableDictionary *items = [self.currInvoice.shoppingCart valueForKey:kBURGERS];
	NSNumber *quantity = [items valueForKey:kQUANTITY];
	[items
     setObject:[NSDecimalNumber numberWithInt:[quantity intValue] + 1]
     forKey:kQUANTITY];
    
     NSString *qtyString = [[items valueForKey:kQUANTITY] stringValue];
    
    self.txtBurgerAmt.text = qtyString;
    
    [self updateTotalDisplay];
    
   }


- (IBAction)btnFries:(id)sender
{
    
    NSMutableDictionary *items = [self.currInvoice.shoppingCart valueForKey:kFRIES];
	NSNumber *quantity = [items valueForKey:kQUANTITY];
	[items
     setObject:[NSDecimalNumber numberWithInt:[quantity intValue] + 1]
     forKey:kQUANTITY];
    
     NSString *qtyString = [[items valueForKey:kQUANTITY] stringValue];
    
    self.txtFriesAmt.text = qtyString;
    
    [self updateTotalDisplay];
    
}

- (IBAction)btnPie:(id)sender
{
    
    NSMutableDictionary *items = [self.currInvoice.shoppingCart valueForKey:kPIES];
	NSNumber *quantity = [items valueForKey:kQUANTITY];
	[items
     setObject:[NSDecimalNumber numberWithInt:[quantity intValue] + 1]
     forKey:kQUANTITY];
    
     NSString *qtyString = [[items valueForKey:kQUANTITY] stringValue];
    
    self.txtPiesAmt.text = qtyString;
    
    [self updateTotalDisplay];
    
}

- (IBAction)btnShake:(id)sender
{
    
    NSMutableDictionary *items = [self.currInvoice.shoppingCart valueForKey:kSHAKES];
	NSNumber *quantity = [items valueForKey:kQUANTITY];
	[items
     setObject:[NSDecimalNumber numberWithInt:[quantity intValue] + 1]
     forKey:kQUANTITY];
    
    NSString *qtyString = [[items valueForKey:kQUANTITY] stringValue];
    
    self.txtShakesAmt.text = qtyString;
    
    [self updateTotalDisplay];
    
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

- (double)getTotalAmount
{
    NSArray *itemList = @[kBURGERS, kFRIES, kSHAKES, kPIES];
    
	double total = 0;
    
	for (NSString *item in itemList) {
		NSMutableDictionary *items = [self.currInvoice.shoppingCart valueForKey:item];
        
		total += ([[items valueForKey:kQUANTITY] intValue] * [[items valueForKey:kPRICE] doubleValue]);
	}
    
	return total;
}

- (void)updateTotalDisplay
{
    double total = [self getTotalAmount];
    NSString *test1 = [NSString stringWithFormat:@"$%.2f", total];
    
    self.txtTotalAmount.text = test1;
    
}
@end
