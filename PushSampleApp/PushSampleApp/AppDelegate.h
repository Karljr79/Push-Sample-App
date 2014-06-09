//
//  OLAppDelegate.h
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <PayPalHereSDK/PPHLocation.h>
#import "LoginViewController.h"
#import "Invoice.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *_invoices;
@property (strong, nonatomic) NSMutableArray *transactionRecords;
@property (strong, nonatomic) LoginViewController *viewController;

-(void)addInvoice:(Invoice *)invoiceToAdd;
@end
