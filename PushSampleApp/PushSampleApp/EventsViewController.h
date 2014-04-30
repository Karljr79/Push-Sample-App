//
//  Tab4ViewController.h
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/7/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController<UIGestureRecognizerDelegate>;
- (IBAction)btnBuyNow:(id)sender;
- (IBAction)btnSubscribe:(id)sender;
- (IBAction)btnCustomEvent:(id)sender;
- (void)viewTapped:(UITapGestureRecognizer *)tgr;
@property (strong, nonatomic) IBOutlet UITextField *txtEventName;

@end
