//
//  InvoiceTableViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "InvoicesViewController.h"
#import "PaymentViewController.h"
#import "Invoice.h"
#import "InvoiceCell.h"
#import "AppDelegate.h"

@interface InvoicesViewController ()

@end

@implementation InvoicesViewController

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
    
    
    //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    id propertyValue = [(AppDelegate *)[[UIApplication sharedApplication] delegate] _invoices];
    self.invoices = propertyValue;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //set the tab bar badge
    
    if (![[appDelegate getUnpaidInvoiceCount] isEqualToString:@"0"])
    {
        [self.navigationController.tabBarItem setBadgeValue:[appDelegate getUnpaidInvoiceCount]];
    }
    
    if (appDelegate.isLoggedIn == FALSE)
    {
        [self showAlertWithTitle:@"Invoice Screen" andMessage:@"Please Log In Before viewing this page"];
        [[self.navigationItem rightBarButtonItem] setEnabled:NO];
    }
    else
    {
        [[self.navigationItem rightBarButtonItem] setEnabled:YES];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.invoices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvoiceCell *cell = (InvoiceCell *)[tableView dequeueReusableCellWithIdentifier:@"InvoiceCell"];
    
    Invoice *invoice = (self.invoices)[indexPath.row];
    cell.amountLabel.text = invoice.getTotalString;
    cell.transactionIDLabel.text = invoice.transactionID;
    cell.transactionIDLabel.textColor = [self colorForStatus:invoice.status];
    cell.amountLabel.textColor = [self colorForStatus:invoice.status];
    cell.statusImageView.image = [self imageForStatus:invoice.status];

    return cell;
}

- (UIImage *)imageForStatus:(NSString*)status
{
    if ([status isEqualToString:@"Paid"]){
        return [UIImage imageNamed:@"check"];
    }
    else if ([status isEqualToString:@"UnPaid"]){
        return [UIImage imageNamed:@"cross"];
    }
    else if ([status isEqualToString:@"Refund"]){
        
        return [UIImage imageNamed:@"Refund"];
    }
        return nil;
}

- (UIColor *)colorForStatus:(NSString*)status
{
    if ([status isEqualToString:@"Paid"]){
        return [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0/255.0 alpha:1.0];
    }
    else if ([status isEqualToString:@"UnPaid"]){
        return [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    }
    else if ([status isEqualToString:@"Refund"]){
        return [UIColor colorWithRed:0.0/255.0 green:0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    return nil;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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

#pragma mark - InvoiceDetailViewControllerDelegate

- (void)invoiceDetailViewControllerDidCancel:(InvoiceCreationViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)invoiceDetailViewControllerDidSave:(InvoiceCreationViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

//12
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentViewController *paymentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentVC"];
    paymentVC.invoiceID = [NSNumber numberWithInt:indexPath.row];
    [self.navigationController pushViewController:paymentVC animated:YES];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddInvoice"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        InvoiceCreationViewController *invoiceDetailViewController = [navigationController viewControllers][0];
        invoiceDetailViewController.delegate = self;
    }
}

@end
