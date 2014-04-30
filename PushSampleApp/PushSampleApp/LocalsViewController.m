//
//  Tab5ViewController.m
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/7/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import "LocalsViewController.h"

@interface LocalsViewController ()

@end

@implementation LocalsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSendLocalPush:(id)sender {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    //[mySDK scheduleLocalNotification:newMsg badge:0 campaign:@"YOUR_CAMPAIGN_TOKEN" date:datePlus];
    
    //grab current date from OS
    NSDate *currentDate = [NSDate date];
    //hard coded to fire in one minute as per specs
    NSDate *datePlus = [currentDate dateByAddingTimeInterval:(1)*60];
    localNotification.alertBody = [NSString stringWithFormat:@"Alert Scheduled at %@", datePlus];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.fireDate = datePlus;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

}
@end
