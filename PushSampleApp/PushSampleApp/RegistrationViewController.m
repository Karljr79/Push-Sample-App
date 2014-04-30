//
//  Tab2ViewController.m
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

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
	
    //check to see if we have a tracking ID registered
    NSString *trackingID = [[NSUserDefaults standardUserDefaults] stringForKey:@"trackingID"];
    
    if(trackingID.length >= 1) {
        //update text field with stored value
        _txtTrackingIDText.text = trackingID;
    }
    else{
        
    }
    
    //handle closing keyboard
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.view addGestureRecognizer:tgr];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRegister:(id)sender {
    
    NSString *currentUserID;
    
    //If an id was entered into the text field
    if (_txtTrackingIDText.text.length >= 1){
        
        // register the device with entered ID (required)
        [self handleRegistration:_txtTrackingIDText.text];
        
        // close the keyboard
        [_txtTrackingIDText resignFirstResponder];
        
        // grab reference to the text field entry and write to the user defaults
        currentUserID = [_txtTrackingIDText text];
    }
    else{
        // register the device with generic ID generated in delegate
        currentUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"Default_Tracking_ID"];
        
        // register using default/random tracking ID
        [self handleRegistration:currentUserID];
    }
    
    _txtTrackingIDText.text = currentUserID;
    
    [self saveIdToUserDefaults:currentUserID];
}

- (IBAction)btnUnregister:(id)sender {
    
    NSString *currentUserID;
    
    //If length of the tracking id is greater than two
    if (_txtTrackingIDText.text.length >= 1){
        
        // unregister the device
        [self handleUnRegistration:_txtTrackingIDText.text];
        
        // close the keyboard
        [_txtTrackingIDText resignFirstResponder];
        
        // reset the text field to display default message
        currentUserID = nil;
    }
    else{
        // register the device with generic ID generated in delegate
        currentUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"Default_Tracking_ID"];
        
        // register using default/random tracking ID
        [self handleUnRegistration:currentUserID];
        
        currentUserID = nil;
    }
    
    [self saveIdToUserDefaults:currentUserID];

}

- (void)handleRegistration:(NSString*)trackingID
{
    // Here you overwrite the generic tracking ID created by our libraries with the one you enter in the text box.
    //[mySDK setTrackingID:_txtTrackingIDText.text];
    
    // show alert
    NSString* messageString = [NSString stringWithFormat: @"Registered ID:%@", _txtTrackingIDText.text];
    UIAlertView *alertID = [[UIAlertView alloc]
                            initWithTitle:@"Sample App"
                            message:messageString  delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil];
    [alertID show];
}

- (void)handleUnRegistration:(NSString*)trackingID
{
    // unregister the device token
    //[mySDK unregisterDevice:[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"]];
    
    
    // show alert
    NSString* messageString = [NSString stringWithFormat: @"UnRegistered ID:%@", _txtTrackingIDText.text];
    UIAlertView *alertID = [[UIAlertView alloc]
                            initWithTitle:@"Sample App"
                            message:messageString  delegate:self
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil];
    [alertID show];
    
    //clear text entry field
    _txtTrackingIDText.text = @"";
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    CGRect framer = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
    [UIView animateWithDuration:0.4f animations:^{
        self.view.frame = framer;}];
    [_txtTrackingIDText resignFirstResponder];
}

-(void)saveIdToUserDefaults:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:@"trackingID"];
        [standardUserDefaults synchronize];
    }
}
@end
