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
#import "AppDelegate.h"
#import "InvoicesViewController.h"
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
    NSString *lastGoodPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastWorkingPassword"];
    
    if(lastGoodUserName)
    {
        self.txtUserName.text = lastGoodUserName;
    }
    
    if(lastGoodPassword)
    {
        self.txtPassword.text = lastGoodPassword;
    }
    
    
    PPHMerchantInfo *currentMerchant = [PayPalHereSDK activeMerchant];
    
    if (currentMerchant != nil)
    {
        self.txtLoginStatus.text = @"Logged In";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnLogin:(id)sender
{
    
    if (!self.txtUserName.text.length)
    {
        [self.txtUserName becomeFirstResponder];
        [self showAlertWithTitle:@"Merchant Login" andMessage:@"Please enter a username"];
    }
    else if (!self.txtPassword.text.length)
    {
        [self.txtPassword becomeFirstResponder];
        [self showAlertWithTitle:@"Merchant Login" andMessage:@"Please enter a password"];
    }
    else
    {
        [self dismissKeyboard];
        
        self.loginSpinner.hidden = FALSE;
        [self.loginSpinner startAnimating];
        
        NSLog(@"Logging into [%@]", self.serviceHost);
    
        // This is the STEP 1 referenced in the documentation at the top of the file.  This executes a /login
        // call against the sample business service.  This isn't a paypal loging, but instead triggers a business
        // system login.
        //
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString: self.serviceHost]];
        httpClient.parameterEncoding = AFJSONParameterEncoding;
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"login" parameters:@{
                                                                                                        @"username": self.txtUserName.text,
                                                                                                        @"password": self.txtPassword.text
                                                                                                        }];
        request.timeoutInterval = 10;
        
        // Execute  /login call
        //
        AFJSONRequestOperation *operation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSON)
        {
            self.loginSpinner.hidden = YES;
            [self.loginSpinner stopAnimating];
            
            // Did we get a successful response with no data?
            if (!JSON)
            {
                // Strange!  Fail the login attempt and alert the user.
                [self showAlertWithTitle:@"Heroku Login Failed"
                              andMessage:[NSString stringWithFormat:
                                          @"Server returned an ambiguous response (nil JSON dictionary). "
                                          @"Check your Username and Password and try again. "
                                          @"If problem continues, might be a good idea to see if the server is healthy [%@]",
                                          self.serviceHost]];
                
                NSLog(@"Apparently logged into Heroku successfully - but we got a nil JSON dict");
                return;
            }
            
            // We received JSON from the sample server.  Let's extract the merchant information
            // and, if it exists, the access_token.
            //
            if ([JSON objectForKey:@"merchant"])
            {
                
                // Let's see if we can pull out everything that we need
                NSString *ticket = [JSON objectForKey:@"ticket"];
                
                // This is your credential for your service. We'll need it later for your server to give us an OAuth token
                // if we don't have one already
                [PPSPreferences setCurrentTicket:ticket];
                
                if (ticket == nil)
                {
                    [self showAlertWithTitle:@"Missing PayPal Login Info"
                                  andMessage:@"Logging in to PayPal requires a non-nil ticket token, but OAuth returned a nil ticket."];
                }
                else
                {
                    // We've got a ticket, we've got a merchant - let's fill out our merchant object which we'll
                    // give to the SDK once we complete the login process.
                    //
                    NSDictionary *yourMerchant = [JSON objectForKey:@"merchant"];
                    
                    self.merchant = [[PPHMerchantInfo alloc] init];
                    self.merchant.invoiceContactInfo = [[PPHInvoiceContactInfo alloc]
                                                        initWithCountryCode: [yourMerchant objectForKey:@"country"]
                                                        city:[yourMerchant objectForKey:@"city"]
                                                        addressLineOne:[yourMerchant objectForKey:@"line1"]];
                    self.merchant.invoiceContactInfo.businessName = [yourMerchant objectForKey:@"businessName"];
                    self.merchant.invoiceContactInfo.state = [yourMerchant objectForKey:@"state"];
                    self.merchant.invoiceContactInfo.postalCode = [yourMerchant objectForKey:@"postalCode"];
                    self.merchant.currencyCode = [yourMerchant objectForKey:@"currency"];
                    
                    if ([JSON objectForKey:@"access_token"])
                    {
                        // The access token exists!   The user must have previously logged into
                        // the sample server.  Let's give these credentials to the SDK and conclude
                        // the login process.
                        [self setActiveMerchantWithAccessTokenDict:JSON];
                    }
                    else {
                        // We don't have an access_token?  Then we need to login to PayPal's oauth process.
                        // Let's procede to that step.
                        [self loginToPayPal:ticket];
                    }
                }
            }
            else
            {
                self.merchant = nil;
                
                [self showAlertWithTitle:@"Heroku Login Failed"
                              andMessage:@"Check your Username and Password and try again."];
                
                NSLog(@"Heroku login attempt failed.");
            }
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
            self.loginSpinner.hidden = YES;
            
            [self showAlertWithTitle:@"Heroku Login Failed"
                          andMessage:[NSString stringWithFormat: @"The Server returned an error: [%@]",
                                      [error localizedDescription]]];
            
            NSLog(@"The Heroku login call failed: [%@]", error);
            
        }];
        
        [operation start];
    
    }
    
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

- (void)dismissKeyboard
{
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

/*
 * Called when we have JSON that contains an access token.  Which this is
 * the case we'll attempt to decrypt the access token and configure the SDK
 * to use it.  If successful this call will conclude the login process and
 * launch the TransactionViewController which is then entry point into the
 * rest of the SDK.
 */
- (void) setActiveMerchantWithAccessTokenDict:(NSDictionary *)JSON
{
	NSString* key = [PPSPreferences currentTicket]; // The sample server encrypted the access token using the 'ticket' it returned in step 1 (the /login call)
	NSString* access_token = [JSON objectForKey:@"access_token"];
	NSString* access = [PPSCryptoUtils AES256Decrypt:access_token  withPassword:key];
    
	if (key == nil || access == nil) {
        
		NSLog(@"Bailing because couldn't decrypt access_code.   key: %@   access: %@   access_token: %@", key, access, access_token);
        
		self.loginSpinner.hidden = YES;
        
        [self showAlertWithTitle:@"Press the Login Button Again"
                      andMessage:@"Looks like something went wrong during the redirect.  Tap Login again to retry."];
        
		return;
	}
    
    // We have valid credentials.
    // The login process has been successful.  Here we complete the process.
    // Let's package them up the credentails into a PPHAccessAcount object and set that
    // object into the PPHMerchant object we're building.
	PPHAccessAccount *account = [[PPHAccessAccount alloc] initWithAccessToken:access
                                                                   expires_in:[JSON objectForKey:@"expires_in"]
                                                                   refreshUrl:[JSON objectForKey:@"refresh_url"] details:JSON];
	self.merchant.payPalAccount = account;  // Set the credentails into the merchant object.
    
    // Since this is a successful login, let's save the user name so we can use it as the default username the next
    // time the sample app is run.
    [[NSUserDefaults standardUserDefaults] setObject:self.txtUserName.text forKey:@"lastWorkingUserName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"lastWorkingPassword"];
    
    // Call setActiveMerchant
    // This is how we configure the SDK to use the merchant info and credentails.
    // Provide the PPHMerchant object we've built, and a key which the SDK will use to uniquely store this merchant's
    // contact information.
    // NOTE: setActiveMerchant will kick off two network requests to PayPal.  These calls request detailed information
    // about the merchant needed so we can take payment for this merchant.  Once those calls are done the completionHandler
    // block will be called.  If successful, status will be ePPHAccessResultSuccess.  Only if this returns successful
    // will the SDK be able to take payment, do invoicing related operations, or do checkin operations for this merchant.
    //
    // Please wait for this call to complete before attempting other SDK operations.
    //
	[PayPalHereSDK setActiveMerchant:self.merchant
                      withMerchantId:self.merchant.invoiceContactInfo.businessName
				   completionHandler: ^(PPHAccessResultType status, PPHAccessAccount* account, NSDictionary* extraInfo) {
                       
                       if (status == ePPHAccessResultSuccess) {
                           // Login complete!
                           // Time to show the sample app UI!
                           //
                           [self transitionToInvoicesViewController];
                       }
                       
                       else {
                           
                           NSLog(@"We have FAILED to setActiveMerchant from setActiveMerchantWithAccessTokenDict, showing error Alert.");
                           
                           [self showAlertWithTitle:@"No PayPal Merchant Account"
                                         andMessage:@"Can't attempt any transactions till you've set up a PayPal Merchant account!"];
                           
                       }
                       
                   }];
    
}

/*
 * Called when we need to obtain pay pal credentials for this merchant.
 * This will execute a /goPayPal call against the sample server running
 * on heroku.  If successful the sample server will return a URL for our
 * merchant to use to log in to PayPal's oauth process.  We direct Safari
 * to that URL.  The mobile web page, running in safari, will ask the
 * merchant to log into their PayPal account.   If the merchant agrees, and
 * the login is successful, Safari will redirect back to our app.  In that
 * case iOS will launch our app via the AppDelegate's handleOpenURL call.
 */
- (void) loginToPayPal:(NSString *)ticket
{
  	NSLog(@"Logging in to PayPal...");
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString: self.serviceHost]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"goPayPal" parameters:@{
                                                                                                       @"username": self.txtUserName.text,
                                                                                                       @"ticket": ticket
                                                                                                       }];
    request.timeoutInterval = 10;
	
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *JSON) {
        
        if (JSON) {
			NSLog(@"PayPal login attempt got some JSON back: [%@]", JSON);
            
			if ([JSON objectForKey:@"url"] && [[JSON objectForKey:@"url"] isKindOfClass:[NSString class]]) {
                
                // FIRE UP SAFARI TO LOGIN TO PAYPAL
                // \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_
                NSString *url = [JSON objectForKey:@"url"];
                NSLog(@"Pointing Safari at URL [%@]", url);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
			}
			else {
                
                // UH-OH - NO URL FOR SAFARI TO FOLLOW, NO ACCESS TOKEN FOR YOU. FAIL.
                // \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_ \_\_
                NSLog(@"FAILURE! Got neither a URL to point Safari to, nor an Access Token - Huh?");
                
                [self showAlertWithTitle:@"PayPal Login Failed"
                              andMessage:@"Didn't get a URL to point Safari at, nor an Access Token - unable to proceed.  Server down?"];
                
			}
            
        }
        else {
			NSLog(@"PayPal login attempt got no JSON back!");
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"The PayPal login attempt failed: [%@]", error);
        
    }];
    
    [operation start];
    
	NSLog(@"Attempting to login to Paypal as \"%@\" with ticket \"%@\"...", self.txtUserName.text, ticket);
}

//If the login was successful, head to the Invoices screen
- (void)transitionToInvoicesViewController
{
    NSUInteger selectedIndex = [self.tabBarController.viewControllers indexOfObject:self];
    
    NSLog(@"Index: %i", selectedIndex);
    
    [self.tabBarController setSelectedIndex:selectedIndex +1];
}


@end
