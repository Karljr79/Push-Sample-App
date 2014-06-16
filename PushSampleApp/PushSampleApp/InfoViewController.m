//
//  SetAmountViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/2/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "InfoViewController.h"
#import <PayPalHereSDK/PayPalHereSDK.h>

#define kStatusWaiting @"Waiting for Card reader"
#define kStatusFound   @"Reader Connected and Ready"

@interface InfoViewController ()

@property (nonatomic,strong) PPHCardReaderBasicInformation *readerInfo;
@property (nonatomic,strong) PPHCardReaderMetadata *readerMetadata;
@property (nonatomic,strong) PPHCardReaderWatcher *cardWatcher;

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[PayPalHereSDK sharedCardReaderManager] beginMonitoring];
    
    if ([[[PayPalHereSDK sharedCardReaderManager] availableDevices] count] > 0)
    {
		self.txtCardReaderStatus.text = kStatusFound;
	}
	else {
		self.txtCardReaderStatus.text = kStatusWaiting;
	}
    
    self.txtVersion.text = [PayPalHereSDK sdkVersion];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[PayPalHereSDK sharedCardReaderManager] endMonitoring:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateReaderInfo
{
    
}

#pragma mark -
#pragma mark PPHSimpleCardReaderDelegate

-(void)didStartReaderDetection:(PPHCardReaderBasicInformation *)readerType
{
    NSLog(@"Detecting Device");
    self.spinCardDetect.hidden = NO;
    [self.spinCardDetect startAnimating];
}

-(void)didDetectReaderDevice:(PPHCardReaderBasicInformation *)reader
{
    NSLog(@"%@", [NSString stringWithFormat:@"Detected %@", reader.friendlyName]);
    self.spinCardDetect.hidden = YES;
    [self.spinCardDetect stopAnimating];
    self.readerInfo = reader;
    
    self.txtCardReaderStatus.text = kStatusFound;
}

-(void)didRemoveReader:(PPHReaderType)readerType
{
    NSLog(@"Reader Removed");
    self.spinCardDetect.hidden = YES;
    [self.spinCardDetect stopAnimating];
    self.readerInfo = nil;
    
    self.txtCardReaderStatus.text = kStatusFound;
}

-(void)didDetectCardSwipeAttempt
{
    NSLog(@"Got a Swipe!!!!!!!!!!!!!!!!!!!!!");
}

-(void)didCompleteCardSwipe:(PPHCardSwipeData*)card
{
	NSLog(@"Got card swipe!");
    
    NSLog(@"Masked Card #:, %@", card.maskedCardNumber);
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

-(void)didReceiveCardReaderMetadata:(PPHCardReaderMetadata *)metadata
{
	if (metadata == nil) {
		NSLog(@"didReceiveCardReaderMetadata got NIL metada! Ignoring..");
		return;
	}
    
	self.readerMetadata = metadata;
    
	if (metadata.serialNumber != nil) {
		NSLog(@"Transaction VC: %@",[NSString stringWithFormat:@"Reader Serial %@", metadata.serialNumber]);
	}
    
	if (metadata.firmwareRevision != nil) {
		NSLog(@"Transaction VC: %@",[NSString stringWithFormat:@"Firmware Revision %@", metadata.firmwareRevision]);
	}
    
	const NSInteger kZero = 0;
    
	if (metadata.batteryLevel != kZero) {
		NSLog(@"Transaction VC: %@",[NSString stringWithFormat:@"Battery Level %ld", (long)metadata.batteryLevel]);
	}
    
}


@end
