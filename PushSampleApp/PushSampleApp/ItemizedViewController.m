//
//  Tab4ViewController.m
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/7/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import "ItemizedViewController.h"

@interface ItemizedViewController ()

@end

@implementation ItemizedViewController

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
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.view addGestureRecognizer:tgr]; // or [self.view addGestureRecognizer:tgr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnCustomEvent:(id)sender {
    if (_txtEventName.text.length < 1){
        // show alert
        NSString* messageString = [NSString stringWithFormat: @"You have not entered an event name"];
        UIAlertView *alertID = [[UIAlertView alloc]
                                initWithTitle:@"Sample App"
                                message:messageString  delegate:self
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil];
        [alertID show];
    }
    else{
        //register the custom event
        //[mySDK registerEvent:_txtEventName.text label:@"Custom Event"];
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    CGRect framer = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
    [UIView animateWithDuration:0.4f animations:^{
        self.view.frame = framer;}];
    [_txtEventName resignFirstResponder];

}

@end
