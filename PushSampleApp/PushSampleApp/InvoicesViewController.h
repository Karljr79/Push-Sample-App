//
//  InvoiceTableViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceCreationViewController.h"
#import "PaymentStatusViewController.h"

@interface InvoicesViewController : UITableViewController <InvoiceDetailViewControllerDelegate>

@property (nonatomic, strong)NSMutableArray *invoices;
- (UIImage *)imageForStatus:(NSString*)status;
- (UIColor *)colorForStatus:(NSString*)status;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;



@end
