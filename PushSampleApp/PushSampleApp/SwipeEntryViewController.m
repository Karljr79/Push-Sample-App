//
//  SwipeEntryViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/4/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import "SwipeEntryViewController.h"
#import "PaymentStatusViewController.h"
#import "AppDelegate.h"
#import <PayPalHereSDK/PayPalHereSDK.h>
#import <PayPalHereSDK/PPHTransactionManager.h>
#import <PayPalHereSDK/PPHTransactionRecord.h>
#import <PayPalHereSDK/PPHTransactionWatcher.h>
#import <PayPalHereSDK/PPHCardReaderDelegate.h>


#define kStatusWaiting @"Waiting for Card reader"
#define kStatusFound   @"Reader Connected and Ready"

@interface SwipeEntryViewController ()

@property (nonatomic,strong) PPHTransactionWatcher *transactionWatcher;
@property (nonatomic,strong) PPHCardReaderWatcher *cardWatcher;
@property BOOL waitingForCardSwipe;
@property BOOL doneWithPayScreen;
@property BOOL isCashTransaction;
@property PPHTransactionResponse *transactionResponse;

@end

@implementation SwipeEntryViewController

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
    
     [[PayPalHereSDK sharedCardReaderManager] beginMonitoring];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PPHTransactionManager *tm = [PayPalHereSDK sharedTransactionManager];
    PPHInvoice *invoice = tm.currentInvoice;
    
    NSLog(@"CURRENT INVOICE %@", invoice.totalAmount.stringValue);
    
    self.transactionWatcher = [[PPHTransactionWatcher alloc] initWithDelegate:self];
    self.cardWatcher = [[PPHCardReaderWatcher alloc] initWithSimpleDelegate:self];
    self.waitingForCardSwipe = YES;
    self.doneWithPayScreen = NO;
    self.isCashTransaction = NO;
    self.spinReader.hidden = YES;
    self.txtReaderStatus.text = kStatusWaiting;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PayPalHereSDK sharedCardReaderManager] endMonitoring:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self.delegate swipeEntryViewControllerDidCancel:self];
}

- (void)showPaymentStatusView
{
    //complete transaction and sync up data
    if(_transactionResponse.record != nil)
    {
        //NSString *myResponse = _transactionResponse.record.transactionId;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        Invoice *myInvoice = [appDelegate._invoices objectAtIndex:self.invoiceID.integerValue];
        myInvoice.transactionResponse = _transactionResponse;
        myInvoice.transactionID = _transactionResponse.record.transactionId;
    }
    
    [self showAlertWithTitle:@"Payment" andMessage:@"Payment Complete, press the done button"];
    
    [[self.navigationItem rightBarButtonItem] setEnabled:YES];
}

#pragma mark PPHTransactionControllerDelegate
-(PPHTransactionControlActionType)onPreAuthorizeForInvoice:(PPHInvoice *)inv withPreAuthJSON:(NSString*) preAuthJSON
{
    NSLog(@"TransactionViewController: onPreAuthorizeForInvoice called");
    return ePPHTransactionType_Continue;
}

-(void)onPostAuthorize:(BOOL)didFail
{
    NSLog(@"TransactionViewController: onPostAuthorize called.  'authorize' %@ fail", didFail ? @"DID" : @"DID NOT");
}

#pragma mark -
#pragma mark PPHSimpleCardReaderDelegate

-(void)didStartReaderDetection:(PPHCardReaderBasicInformation *)readerType
{
    NSLog(@"Detecting Device");
    self.spinReader.hidden = NO;
    [self.spinReader startAnimating];
}

-(void)didDetectReaderDevice:(PPHCardReaderBasicInformation *)reader
{
    NSLog(@"%@", [NSString stringWithFormat:@"Detected %@", reader.friendlyName]);
    self.spinReader.hidden = YES;
    [self.spinReader stopAnimating];
    
    self.txtReaderStatus.text = kStatusFound;
}

-(void)didRemoveReader:(PPHReaderType)readerType
{
    NSLog(@"Reader Removed");
    self.spinReader.hidden = NO;
    [self.spinReader startAnimating];
    
    self.txtReaderStatus.text = kStatusWaiting;
}

-(void)didCompleteCardSwipe:(PPHCardSwipeData*)card
{
	NSLog(@"Got card swipe!");
}

-(void)didFailToReadCard
{
	NSLog(@"Card swipe failed!!");
    
    UIAlertView *alertView;
    
    alertView = [[UIAlertView alloc]
                 initWithTitle:@"Problem reading card"
                 message: @"Looks like there was a failed swipe.  Please try again."
                 delegate:nil
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:nil];
    
    [alertView show];
}

#pragma mark -
#pragma mark PPHTransactionManagerDelegate overrides

-(void)onPaymentEvent:(PPHTransactionManagerEvent *) event
{
    if(event.eventType == ePPHTransactionType_Idle) {
        [self.spinReader stopAnimating];
        self.spinReader.hidden = YES;
    }
    else {
        [self.spinReader startAnimating];
        self.spinReader.hidden = NO;
    }
    
    NSLog(@"Our local instance of PPHTransactionWatcher picked up a PPHTransactionManager event notification: <%@>", event);
    if(event.eventType == ePPHTransactionType_CardDataReceived && self.waitingForCardSwipe)  {
        
        self.waitingForCardSwipe = NO;
        
        //Now ask to authorize (and take) payment.
        [[PayPalHereSDK sharedTransactionManager] processPaymentWithPaymentType:ePPHPaymentMethodSwipe
                                                      withTransactionController:self
                                                              completionHandler:^(PPHTransactionResponse *response) {
                                                                  self.transactionResponse = response;
                                                                  if(response.error) {
                                                                      [self showPaymentStatusView];
                                                                  }
                                                                  else {
                                                                      // Is a signature required for this payment?  If so
                                                                      // then let's collect a signature and provide it to the SDK.
                                                                      if(response.isSignatureRequiredToFinalize) {
                                                                          //[self collectSignatureAndFinalizePurchaseWithRecord]; //TODO Signature Page
                                                                          NSLog(@"Signature Required");
                                                                      }
                                                                      else {
                                                                          // All done.  Tell the user the good news.
                                                                          //Let's exit the payment screen once they hit OK
                                                                          _doneWithPayScreen = YES;
                                                                          [self showPaymentStatusView];
                                                                      }
                                                                      
                                                                  }
                                                              }];
    }
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    PaymentStatusViewController *paymentVC = [navigationController viewControllers][0];
    paymentVC.transactionResponse = self.transactionResponse;
    paymentVC.invoiceID = self.invoiceID;
}

@end
