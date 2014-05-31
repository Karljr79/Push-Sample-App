//
//  InvoiceTableViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import "InvoicesViewController.h"
#import "Invoice.h"
#import "InvoiceCell.h"

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
    float invoiceAmount = invoice.totalAmount.floatValue;
    cell.amountLabel.text = [NSString stringWithFormat:@"%f", invoiceAmount];
    cell.statusLabel.text = invoice.status;
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
        return nil;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

#pragma mark - InvoiceDetailViewControllerDelegate

- (void)invoiceDetailViewControllerDidCancel:(InvoiceDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)invoiceDetailViewControllerDidSave:(InvoiceDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
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
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddInvoice"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        InvoiceDetailViewController *invoiceDetailViewController = [navigationController viewControllers][0];
        invoiceDetailViewController.delegate = self;
    }
}

@end
