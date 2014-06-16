//
//  SetAmountViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/2/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayPalHereSDK/PPHCardReaderDelegate.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface InfoViewController : UIViewController <PPHSimpleCardReaderDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *txtVersion;
@property (weak, nonatomic) IBOutlet UILabel *txtCardReaderStatus;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinCardDetect;
@property (weak, nonatomic) IBOutlet UILabel *txtReaderType;
@property (weak, nonatomic) IBOutlet UILabel *txtReaderFamily;
@property (weak, nonatomic) IBOutlet UILabel *txtReaderName;
@property (weak, nonatomic) IBOutlet UILabel *txtReaderSerial;
@property (weak, nonatomic) IBOutlet UILabel *txtReaderRev;
@property (weak, nonatomic) IBOutlet UILabel *txtReaderBattery;
@property (weak, nonatomic) IBOutlet UIProgressView *barBattery;


@end
