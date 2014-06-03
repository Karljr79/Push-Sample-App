//
//  ManualEntryViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/3/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ManualEntryViewController;

@protocol ManualEntryViewControllerDelegate <NSObject>
- (void)manualEntryViewControllerDidCancel:(ManualEntryViewController *)controller;
@end

@interface ManualEntryViewController : UITableViewController

@property (nonatomic, weak) id <ManualEntryViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtCCNumber;

-(IBAction)cancel:(id)sender;

@end
