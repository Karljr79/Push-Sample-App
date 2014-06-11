//
//  Tab2ViewController.h
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayPalHereSDK/PayPalHereSDK.h>

@interface LoginViewController : UIViewController <
            UIGestureRecognizerDelegate,
            UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginSpinner;
@property (weak, nonatomic) IBOutlet UILabel *txtServiceUsed;
@property (weak, nonatomic) IBOutlet UILabel *txtLoginStatus;

@property (nonatomic) IBOutlet PPHMerchantInfo *merchant;

- (IBAction)btnLogin:(id)sender;
- (void)viewTapped:(UITapGestureRecognizer *)tgr;
- (void)handleRegistration:(NSString*)trackingID;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)dismissKeyboard;
- (void)setActiveMerchantWithAccessTokenDict:(NSDictionary *)JSON;
- (void)transitionToInvoicesViewController;

@end
