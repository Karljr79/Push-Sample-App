//
//  PaymentViewController.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 6/2/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"

@interface PaymentViewController : UIViewController

@property (nonatomic, weak) Invoice *invoiceToPay;

@end
