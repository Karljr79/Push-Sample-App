//
//  InvoiceTableViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceDetailViewController.h"

@interface InvoicesViewController : UITableViewController <InvoiceDetailViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *invoices;
- (UIImage *)imageForStatus:(NSString*)status;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
