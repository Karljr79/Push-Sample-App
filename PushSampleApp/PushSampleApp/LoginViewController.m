//
//  Tab2ViewController.m
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//
#import "PPSPreferences.h"
#import "PPSCryptoUtils.h"

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "PushAppDelegate.h"
#import <PayPalHereSDK/PayPalHereSDK.h>

@interface LoginViewController ()

@property (nonatomic, strong) NSString *serviceHost;
@property (nonatomic, strong) NSURL *serviceArray;

@end

@implementation LoginViewController

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
    
    //make sure that the progress spinner is hidden
    self.loginSpinner.hidden = TRUE;
    
    self.txtUserName.delegate = self;
    self.txtPassword.delegate = self;
    
//#warning Change this block to use your server's URL
    //This is the PayPal sample server
    self.serviceHost = @"http://desolate-wave-3684.herokuapp.com";
    //This is the level of service to use
    self.serviceArray = [NSURL URLWithString:@"https://www.sandbox.paypal.com/webapps/"];
    self.txtServiceUsed.text = @"Sandbox";
    
//#warning This is where we set the PP environment
    //tell the SDK to use this endpoint
    [PayPalHereSDK setBaseAPIURL:self.serviceArray];
    NSLog(@"PPH SDK is using the following endpoint: %@", self.serviceArray);
    
    //handle closing keyboard
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.view addGestureRecognizer:tgr];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Did we successfully log in in the past?  If so, let's prefill the username box with
    // that last-good user name.
    NSString *lastGoodUserName = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastWorkingUserName"];
    if(lastGoodUserName) {
        self.txtUserName.text = lastGoodUserName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnLogin:(id)sender {
    
    if (!self.txtUserName.text.length) {
        [self.txtUserName becomeFirstResponder];
        [self showAlertWithTitle:@"Merchant Login" andMessage:@"Please enter a username"];
    }
    else if (!self.txtPassword.text.length) {
        [self.txtPassword becomeFirstResponder];
        [self showAlertWithTitle:@"Merchant Login" andMessage:@"Please enter a password"];
    }
    else {
        [self dismissKeyboard];
        
        self.loginSpinner.hidden = FALSE;
        
        [self.loginSpinner startAnimating];
        
        NSLog(@"Logging into [%@]", self.serviceHost);
    }
    
//#warning Change here if your sample server has another method
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:self.serviceHost]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    //here we call the login path on the sample server change this if using your own version
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"login" parameters:@{
                            @"username": self.txtUserName.text,
                            @"password": self.txtPassword.text
                            }];
    request.timeoutInterval = 10;
    
    
    
    
    
    
    
    
    
    //[self saveIdToUserDefaults:currentUserID];
}


- (void)handleRegistration:(NSString*)trackingID
{
    // show alert
    NSString* messageString = [NSString stringWithFormat: @"Registered ID:%@", _txtUserName.text];
    UIAlertView *alertID = [[UIAlertView alloc]
                            initWithTitle:@"Sample App"
                            message:messageString  delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil];
    [alertID show];
}


//close keyboard if view is tapped
- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    CGRect framer = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
    [UIView animateWithDuration:0.4f animations:^{
        self.view.frame = framer;}];
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
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

-(void)saveIdToUserDefaults:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:@"lastWorkingUserName"];
        [standardUserDefaults synchronize];
    }
}

- (void)dismissKeyboard
{
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}
@end
