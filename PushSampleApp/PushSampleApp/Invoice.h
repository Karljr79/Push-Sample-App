//
//  Invoice.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invoice : NSObject

@property (nonatomic, copy) NSDecimalNumber *totalAmount;
@property (nonatomic, assign) NSString *status;
@property (nonatomic, copy) NSString *transactionID;
@property (nonatomic, copy) NSMutableDictionary *shoppingCart;

@end
