//
//  CheckInViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 7/7/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import "CheckInViewController.h"
#import "CheckInCustomerCell.h"
#import "PaymentStatusViewController.h"

#import <PayPalHereSDK/PayPalHereSDK.h>
#import <PayPalHereSDK/PPHLocationCheckin.h>
#import <PayPalHereSDK/PPHTransactionRecord.h>
#import <PayPalHereSDK/PPHTransactionWatcher.h>

@interface CheckInViewController ()

@property (nonatomic, strong) NSMutableArray *checkedInClients;
@property (nonatomic, strong) PPHLocationWatcher *locationWatcher;
@property (nonatomic, strong) PPHTransactionResponse *transactionResponse;

@end

@implementation CheckInViewController

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
    
    [[self.navigationItem rightBarButtonItem] setEnabled:NO];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CheckInCellIdentifier"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.checkinLocationId = appDelegate.merchantLocation.locationId;
    self.locationWatcher = [[PayPalHereSDK sharedLocalManager] watcherForLocationId:self.checkinLocationId withDelegate:self];
    
    _locationWatcher.delegate = self;
    [_locationWatcher updatePeriodically:20 withMaximumInterval:60];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    
    // If we are becoming invisible then let's ask
    // the location watcher to stop sending us periodic updates.  Also
    // clear out the delegate.
    _locationWatcher.delegate = nil;
    [_locationWatcher stopPeriodicUpdates];
}

//handle cancel button
- (IBAction)cancel:(id)sender
{
    [self.delegate checkInViewControllerDidCancel:self];
}

-(void)takePaymentUsingCheckinClient:(PPHLocationCheckin*)checkinMember
{
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];
    [tm setCheckedInClient:checkinMember];
    [tm processPaymentWithPaymentType:ePPHPaymentMethodPaypal
            withTransactionController:self
                    completionHandler:^(PPHTransactionResponse *record) {

                        if (record.error) {
                            NSString *message = [NSString stringWithFormat:@"Payment using checkin Failed with an error: %@", record.error.apiMessage];
                            [self showAlertWithTitle:@"Payment Failed" andMessage:message];
                        }
                        else {
                            self.transactionResponse = record;
                            [self completeTransaction];
                        }
                        tm.ignoreHardwareReaders = NO;    //Back to the default running state.
                    }];
    
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

-(void)completeTransaction
{
    //complete transaction and sync up data
    if(self.transactionResponse.record != nil)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // Add the record into an array so that we can issue a refund later.
        Invoice* myInvoice = (Invoice *)[appDelegate._invoices objectAtIndex:self.invoiceID.integerValue];
        
        myInvoice.transactionResponse = self.transactionResponse;
        myInvoice.transactionID = self.transactionResponse.record.transactionId;
    }
    
    [self showAlertWithTitle:@"Payment" andMessage:@"PayPal payment Complete, press the done button"];
    
    [[self.navigationItem rightBarButtonItem] setEnabled:YES];
    [[self.navigationItem leftBarButtonItem] setEnabled:YES];
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.checkedInClients count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckInCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckInCellIdentifier" forIndexPath:indexPath];
    
    //has the cell been initialized?
    if (cell == nil)
    {
        cell = [[CheckInCustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckInCellIdentifier"];
    }
    
    PPHLocationCheckin *client = [self.checkedInClients objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"default_image.jpg"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:client.photoUrl];
        if (imgData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *actualImage = [UIImage imageWithData:imgData];
                CheckInCustomerCell *c = (CheckInCustomerCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                c.imageView.image = actualImage;
                [c.imageView setNeedsDisplay];
            });
        }
    });

    // load the name of the checked in client
    cell.textLabel.text = client.customerName;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //we only have one section
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPHLocationCheckin *client = [self.checkedInClients objectAtIndex:indexPath.row];
    if (nil != client){
        NSLog(@"Calling takePaymentUsingCheckinClient with the checkedin client: %@",client.customerName);
        [self takePaymentUsingCheckinClient:client];
    }else{
        NSLog(@"Oops! Selected row has no checkeding client..");
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    PaymentStatusViewController *paymentVC = [navigationController viewControllers][0];
    paymentVC.transactionResponse = self.transactionResponse;
    paymentVC.invoiceID = self.invoiceID;
}


#pragma mark PPHLocationWatcherDelegate
-(void)locationWatcher:(PPHLocationWatcher *)watcher didCompleteUpdate:(NSArray *)openTabs wasModified:(BOOL)wasModified
{
    //here is where we grab the checked in clients from PayPal
    NSLog(@"Got the response didCompleteUpdate from Location Watcher with list of checked-in clients. No. of clients: %d",[openTabs count]);
    self.checkedInClients = [[NSMutableArray alloc] initWithArray:openTabs];
    [self.tableView reloadData];
}

-(void)locationWatcher: (PPHLocationWatcher*) watcher didDetectNewTab: (PPHLocationCheckin*) checkin
{
    NSLog(@"Got the new checked in client after did the update. Need to update the rows");
}

-(void)locationWatcher: (PPHLocationWatcher*) watcher didDetectRemovedTab: (PPHLocationCheckin*) checkin
{
    NSLog(@"One of the checked in client checked out. Need to update the rows");
}

-(void)locationWatcher: (PPHLocationWatcher*) watcher didReceiveError: (PPHError*) error
{
    NSLog(@"Oops got the error while looking for checked in clients..");
}

@end
