//
//  InvoiceCellTableViewCell.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *transactionIDLabel;
@property (nonatomic, weak) IBOutlet UIImageView *statusImageView;

@end
