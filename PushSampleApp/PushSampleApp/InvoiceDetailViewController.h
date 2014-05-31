//
//  InvoiceDetailViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvoiceDetailViewController;

@protocol InvoiceDetailViewControllerDelegate <NSObject>
- (void)invoiceDetailViewControllerDidCancel:(InvoiceDetailViewController *)controller;
- (void)invoiceDetailViewControllerDidSave:(InvoiceDetailViewController *)controller;
@end

@interface InvoiceDetailViewController : UITableViewController

@property (nonatomic, weak) id <InvoiceDetailViewControllerDelegate> delegate;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
