//
//  Tab2ViewController.h
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController<UIGestureRecognizerDelegate>;
@property (weak, nonatomic) IBOutlet UITextField *txtTrackingIDText;
- (IBAction)btnRegister:(id)sender;
- (IBAction)btnUnregister:(id)sender;
- (void)viewTapped:(UITapGestureRecognizer *)tgr;
- (void)saveIdToUserDefaults:(NSString*)myString;
- (void)handleRegistration:(NSString*)trackingID;
- (void)handleUnRegistration:(NSString*)trackingID;

@end
