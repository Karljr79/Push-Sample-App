//
//  SetAmountViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/2/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "InfoViewController.h"
#import "AppDelegate.h"
#import <PayPalHereSDK/PayPalHereSDK.h>

#define kStatusWaiting @"Waiting for Card reader"
#define kStatusFound   @"Reader Connected and Ready"

@interface InfoViewController ()

@property (nonatomic,strong) PPHCardReaderBasicInformation *readerInfo;
@property (nonatomic,strong) PPHCardReaderMetadata *readerMetadata;
@property (nonatomic,strong) PPHCardReaderWatcher *cardWatcher;
@property (nonatomic,strong) CLLocation *merchantLocation;
@property (nonatomic,strong) CLLocationManager *locationManager;

@property BOOL gotValidLocation;
@property BOOL isMerchantCheckinPending;

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
    //handle initail state for check in switch
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.isMerchantCheckedin){
        [self.switchCheckIn setOn:YES animated:YES];
    }else{
        [self.switchCheckIn setOn:NO animated:YES];
    }
    self.spinCheckIn.hidden = YES;
    
    self.merchantLocation = nil;
    self.isMerchantCheckinPending = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    NSLog(@"In settings view controller");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.locationManager stopUpdatingLocation];
}

- (void)dealloc
{
    [self.locationManager stopUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.cardWatcher = [[PPHCardReaderWatcher alloc] initWithSimpleDelegate:self];
    
    [[PayPalHereSDK sharedCardReaderManager] beginMonitoring];
    
    if ([[[PayPalHereSDK sharedCardReaderManager] availableDevices] count] > 0)
    {
		self.txtCardReaderStatus.text = kStatusFound;
	}
	else {
		self.txtCardReaderStatus.text = kStatusWaiting;
	}
    
    if (appDelegate.isLoggedIn == FALSE)
    {
        self.switchCheckIn.enabled = FALSE;
    }
    else
    {
        self.switchCheckIn.enabled = TRUE;
    }
    
    
    self.txtVersion.text = [PayPalHereSDK sdkVersion];
    
    self.spinCardDetect.hidden = YES;

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
    self.txtReaderType.text = [self getReaderType];
    self.txtReaderFamily.text = self.readerInfo.family;
    self.txtReaderName.text = self.readerInfo.friendlyName;
}

- (NSString*)getReaderType
{
    NSInteger type = self.readerInfo.readerType;
    
    switch (type)
    {
        case 1:
            return @"Audio Jack Reader";
            break;
        case 2:
            return @"Dock Port Reader";
            break;
        case 3:
            return @"Chip and Pin BT";
            break;
        default:
            return @"Unknown Type";
            break;
    }
}

- (IBAction)toggleCheckIn:(id)sender
{
    NSLog(@"Check-in button toggled!");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (appDelegate.isLoggedIn == TRUE)
    {
        if (self.switchCheckIn.on)
        {
            if (nil != self.merchantLocation)
            {
                self.switchCheckIn.hidden = YES;
                self.spinCheckIn.hidden = NO;
                [self.spinCheckIn startAnimating];
                [self getMerchantCheckin:self.merchantLocation];
            }
            else
            {
                self.isMerchantCheckinPending = TRUE;
            }
        }
        else
        {
            NSLog(@"In Check In Switch Off");
            [self.switchCheckIn setOn:NO animated:YES];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            PPHLocation *myLocation = appDelegate.merchantLocation;
            myLocation.isAvailable = NO;
            appDelegate.merchantLocation = nil;
            appDelegate.isMerchantCheckedin = NO;
        }
    }
    else
    {
        [self showAlertWithTitle:@"Merchant Check-in" andMessage:@"Please log in before trying to check in"];
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
    
    [self updateReaderInfo];
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

//would be cool if this were implemented!!!
-(void)didReceiveCardReaderMetadata:(PPHCardReaderMetadata *)metadata
{
	if (metadata == nil) {
		NSLog(@"didReceiveCardReaderMetadata got NIL metadata! Ignoring..");
		return;
	}
    
	self.readerMetadata = metadata;
    
	if (metadata.serialNumber != nil)
    {
		NSLog(@"InfoView: %@",[NSString stringWithFormat:@"Reader Serial %@", metadata.serialNumber]);
        self.txtReaderSerial.text = metadata.serialNumber;
	}
    
	if (metadata.firmwareRevision != nil)
    {
		NSLog(@"InfoView: %@",[NSString stringWithFormat:@"Firmware Revision %@", metadata.firmwareRevision]);
        self.txtReaderRev.text = metadata.firmwareRevision;
	}
    
	const NSInteger kZero = 0;
    
	if (metadata.batteryLevel != kZero)
    {
        NSString *batLevel = [NSString stringWithFormat:@"%ld", (long)metadata.batteryLevel];
        
		NSLog(@"InfoView: %@",[NSString stringWithFormat:@"Battery Level %ld", (long)metadata.batteryLevel]);
        
        self.barBattery.progress = metadata.batteryLevel/100;
        self.txtReaderBattery.text = batLevel;
        
	}
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // We just set this once in the sample app. In a real app you would want to update the location as the merchant moves any meaningful distance. Threshold should be set by your needs, but usually something like 1/4 mile would work
    NSLog(@"Got the LocationUpdate. newLocation Latitude:%f Longitude:%f ",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    if (!self.gotValidLocation) {
        self.gotValidLocation = YES;
        self.merchantLocation = newLocation;
        [self.locationManager stopUpdatingLocation];
        if (self.isMerchantCheckinPending){
            self.isMerchantCheckinPending = NO;
            [self getMerchantCheckin:self.merchantLocation];
        }
    }
}

#pragma mark - Merchant Location getter
-(void) getMerchantCheckin: (CLLocation*)newLocation {
    [[PayPalHereSDK sharedLocalManager] beginGetLocations:^(PPHError *error, NSArray *locations){
        if (error) {
            return;
        }
        PPHLocation *myLocation = nil;
        if (nil != locations && 0 < [locations count]){
            NSLog(@"This merchant has already checked-in locations. Will try to find if the current location is in the list or not");
            NSString *currentName = @"Karl Sample App Location";
            if (currentName && currentName.length > 0) {
                for (PPHLocation *loc in locations) {
                    if ([loc.internalName isEqualToString:currentName]) {
                        NSLog(@"Yes. we found the current location as one of the merchant's checked-in locations.");
                        myLocation = loc;
                        break;
                    }
                }
            }
        }
        
        if (nil == myLocation){
            NSLog(@"We didn't find or match the current location in any of the merchants checked-in locations. Hence creating the new checking location");
            myLocation = [[PPHLocation alloc] init];
        }
        
        myLocation.contactInfo = [PayPalHereSDK activeMerchant].invoiceContactInfo;
        myLocation.internalName = @"Karl Sample App Location";
        myLocation.displayMessage = myLocation.contactInfo.businessName;
        myLocation.gratuityType = ePPHGratuityTypeStandard;
        myLocation.checkinType = ePPHCheckinTypeStandard;
        myLocation.contactInfo.countryCode=@"US";
        myLocation.contactInfo.lineOne=@"2211 North 1st Street";
        myLocation.contactInfo.lineTwo=@"San Jose";
        myLocation.logoUrl = @"https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQ3TotXBdfo9zyQhf4eCP33T6vQXh3A9GAe_lsqUOVLMNbdLolO";
        myLocation.location = newLocation.coordinate;
        myLocation.isMobile = YES;
        myLocation.isAvailable = YES;
        
        [myLocation save:^(PPHError *error) {
            if (error == nil) {
                NSLog(@"Successfully saved the current location with locationID: %@",myLocation.locationId);
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.merchantLocation = myLocation;
                appDelegate.isMerchantCheckedin = YES;
                [self.switchCheckIn setOn:YES animated:YES];
            }else{
                NSLog(@"Oops.. We got error while saving the location. Error Code: %ld Error Description: %@",(long)error.code, error.description);
                [self.switchCheckIn setOn:NO animated:YES];
            }
            [self.spinCheckIn stopAnimating];
            self.spinCheckIn.hidden = true;
            self.switchCheckIn.hidden = NO;
        }];
    }];
}

@end
