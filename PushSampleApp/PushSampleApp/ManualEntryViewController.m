//
//  ManualEntryViewController.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/3/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import "ManualEntryViewController.h"
#import <PayPalHereSDK/PayPalHereSDK.h>

#define kTitle		@"Manual Payment"

@interface ManualEntryViewController ()

@end

@implementation ManualEntryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the delegate for the text field
    [self.txtCCNumber setDelegate:self];
    
    //make sure spinny is hidden
    self.spinProcessing.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    //close this and return to payment screen
    [self.delegate manualEntryViewControllerDidCancel:self];
}

//this button handles packaging up entries and submitting for payment
- (IBAction)btnPayment:(id)sender {
    NSString *strCCNumber = self.txtCCNumber.text;
    NSString *strCCExpMonth = self.txtCCMonth.text;
    NSString *strCCExpYear = self.txtCCYear.text;
    NSString *strCCCvv2 = self.txtCVV2.text;
    
    if(![self checkCCNumberValidity:strCCNumber])
    {
        [self showAlertWithTitle:kTitle andMessage:@"Card Number is Invalid"];
    }
    else if(![self checkExpDateWithMonth:strCCExpMonth andYear:strCCExpYear])
    {
        [self showAlertWithTitle:kTitle andMessage:@"Expiration Date is Invalid or Missing"];
    }
    else if(![self checkCVV2Validity:strCCCvv2])
    {
        [self showAlertWithTitle:kTitle andMessage:@"CVV2 in Invalid or Missing"];
    }
    else
    {
        //get the spinner going
        self.spinProcessing.hidden = NO;
        [self.spinProcessing startAnimating];
        
        //format the date usong NSDateComponents
        NSDateComponents *expDateFormatter = [[NSDateComponents alloc] init];
        [expDateFormatter setMonth:strCCExpMonth.integerValue];
        [expDateFormatter setYear:strCCExpYear.integerValue];
        
        //enter cc details into PPHCardNot Present Data
        PPHCardNotPresentData* pphCardData = [[PPHCardNotPresentData alloc] init];
        pphCardData.cardNumber = strCCNumber;
        pphCardData.cvv2 = strCCCvv2;
        pphCardData.expirationDate = [[NSCalendar currentCalendar] dateFromComponents:expDateFormatter];
        
        
    }
    
    
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

-(BOOL)checkCCNumberValidity:(NSString *)cardNumber
{
    if(cardNumber == nil || cardNumber.length < 15)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

-(BOOL)checkCVV2Validity:(NSString *)cvv2
{
    if(cvv2 == nil || cvv2.length < 3)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

-(BOOL)checkExpDateWithMonth:(NSString *)expMonth andYear:(NSString *)expYear
{
    if(expMonth == nil || expYear == nil)
    {
        return FALSE;
    }
    else if(2 != expMonth.length || 4 != expYear.length)
    {
        return FALSE;
    }
    else if(12 < expMonth.integerValue || ([self getCurrentYear].integerValue > expYear.integerValue))
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

-(void)imageForCardType
{
    PPHCardNotPresentData* pphCardData = [[PPHCardNotPresentData alloc] init];
    pphCardData.cardNumber = self.txtCCNumber.text;
    
    //log the type of card entered
    NSLog(@"Type of Card %i", [pphCardData cardType]);
    
    if([pphCardData cardType] == 1)
    {
        self.imgCardType.image = [UIImage imageNamed:@"logoVisa"];
    }
    else if([pphCardData cardType] == 2)
    {
        self.imgCardType.image = [UIImage imageNamed:@"logoMC"];
    }
    else if([pphCardData cardType] == 4)
    {
        self.imgCardType.image = [UIImage imageNamed:@"logoAmex"];
    }
    else
    {
        return;
    }
}

-(NSString*) getCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    return yearString;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //close keyboard
	[textField resignFirstResponder];
    
    //set image
    [self imageForCardType];
    
	return YES;
    
}

@end
