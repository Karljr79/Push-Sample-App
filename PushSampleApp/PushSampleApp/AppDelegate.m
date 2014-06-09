//
//  OLAppDelegate.m
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import "AppDelegate.h"
#import "Invoice.h"
#import "InvoicesViewController.h"
#import <PayPalHereSDK/PayPalHereSDK.h>

@interface AppDelegate() <PPHLoggingDelegate>

@property (nonatomic,strong) id<PPHLoggingDelegate> sdkLogger;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set the tab bar button colors
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.0/255.0 green:12.0/255.0 blue:250.0/255.0 alpha:1.0]];
    
    self._invoices = [NSMutableArray arrayWithCapacity:30];
    self.transactionRecords = [NSMutableArray arrayWithCapacity:30];
    
    self.sdkLogger = [PayPalHereSDK loggingDelegate];
    [PayPalHereSDK setLoggingDelegate:self];
    
    //Set BN Code
    [PayPalHereSDK setReferrerCode:@"Karl's Sample"];
    
    // Either the app, or the SDK must requrest location access if we'd like
    // the SDK to take payments.
    [PayPalHereSDK askForLocationAccess];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //Log the device token for debugging purposes
    NSLog(@"My token is: %@", deviceToken);
    
    //store the device token in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:[deviceToken description] forKey:@"device_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //handle receipt of push when the app is in the foreground
    //[mySDK didReceiveNotification:application notification:userInfo];
    
    //in this implementation we create a UIAlertView to handle the message display
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        NSString *cancelTitle = @"Close";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Push Sample App"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        //Do stuff that you would do if the application was not active
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //handle receipt of local notification while the app is in the foreground
    //[mySDK didAcceptLocalNotification:application notification:notification];
    
    NSLog(@"Notification Received, %@, set for date %@", notification.alertBody, notification.fireDate);
    
    //in this implementation we create a UIAlertView to handle the message display
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        NSString *cancelTitle = @"Close";
        NSString *message = notification.alertBody;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Push Sample App"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        //Do stuff that you would do if the application was not active
    }
    
    //handle user info/meta data from the push
    if (notification !=nil && [notification.userInfo valueForKey:@"myKey"] != [NSNull null] && [[notification.userInfo valueForKey:@"myKey"] length] > 0 ) {
        
        NSString *keyString=[NSString stringWithFormat:@"%@",[notification.userInfo valueForKey:@"myKey"]];
        
        NSLog(@"The Value is: %@", keyString);
        
    } else {
        //Add handlers here for empty user info if necessary
    }
    
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	if ([url.host isEqualToString:@"oauth"]) {
        
		NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
		for (NSString *keyValuePair in [url.query componentsSeparatedByString:@"&"]) {
			NSArray *pair = [keyValuePair componentsSeparatedByString:@"="];
			if (!(pair && [pair count] == 2)) continue;
            NSString *escapedData = [pair objectAtIndex:1];
            escapedData = [escapedData stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			[query setObject:escapedData forKey:[pair objectAtIndex:0]];
		}
        
		if ([query objectForKey:@"access_token"] &&
			[query objectForKey:@"expires_in"] &&
			[query objectForKey:@"refresh_url"] &&
			[self.viewController isKindOfClass:[LoginViewController class]]) {
			[self.viewController setActiveMerchantWithAccessTokenDict:query];
		}
        
	}
	else {
		NSLog(@"%s url.host is NOT \"oauth\" so we're leaving without doing anything!", __FUNCTION__);
	}
    
	return YES;
}

-(void)addInvoice:(Invoice*)invoiceToAdd
{
    [self._invoices addObject:invoiceToAdd];
}

// Let's intercept the logging messages of the SDK
// and display them so we can see what's happening.
//
#pragma mark PPHLoggingDelegate methods
-(void)logPayPalHereInfo:(NSString *)message {
    NSLog(@"%@", message);
}

-(void)logPayPalHereError:(NSString *)message {
    NSLog(@"%@", message);
    [self.sdkLogger logPayPalHereError: message];
}

-(void)logPayPalHereWarning:(NSString *)message {
    NSLog(@"%@", message);
}

-(void)logPayPalHereDebug:(NSString *)message {
    NSLog(@"Debug: %@", message);
}

-(void)logPayPalHereHardwareInfo:(NSString *)message {
    NSLog(@"Debug: %@", message);
}

@end
