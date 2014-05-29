//
//  OLAppDelegate.m
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import "PushAppDelegate.h"

//TODO - Add global login bool

@implementation PushAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //Sample App start session call(REQUIRED), for NSLog output use debugsessionwithlaunchoptions.
    //place a key called APP_KEY in your info.plist file.  Your app key is located on the Sample App dashboard
    //This call allows for session tracking.  WIthout it we will not gather session data or report push opens/events
    
    //[mySDK debugSessionWithLaunchOptions:launchOptions];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:72.0/255.0 green:46.0/255.0 blue:128.0/255.0 alpha:1.0]];
    // Override point for customization after application launch.
    

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"] != nil){
        //register the device token with Sample App.  The tracking ID field is blank because at this point the user is anonymous.
        //if you knew the tracking id at this point you could pass it in.  For demo purposes this app is set up where you enter
        //the tracking id at a later point using "setTrackingID"
        //[mySDK registerDevice:[[NSUserDefaults standardUserDefaults]objectForKey:@"device_token"] withTrackingId:@""];
    }
    else{
        NSLog(@"FAILED TO GET DEVICE TOKEN");
    }
    
    
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

@end
