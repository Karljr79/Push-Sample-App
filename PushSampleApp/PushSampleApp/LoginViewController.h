//
//  Tab2ViewController.h
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <
            UIGestureRecognizerDelegate,
            UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginSpinner;
@property (weak, nonatomic) IBOutlet UILabel *txtServiceUsed;
- (IBAction)btnLogin:(id)sender;
- (void)viewTapped:(UITapGestureRecognizer *)tgr;
- (void)saveIdToUserDefaults:(NSString*)myString;
- (void)handleRegistration:(NSString*)trackingID;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)dismissKeyboard;

@end
