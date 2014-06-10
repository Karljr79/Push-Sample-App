//
//  Invoice.h
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PayPalHereSDK/PPHTransactionManager.h>
#import <PayPalHereSDK/PPHTransactionRecord.h>

@interface Invoice : NSObject

@property (nonatomic, copy) NSDecimalNumber *totalAmount;
@property (nonatomic, assign) NSString *status;
@property (nonatomic, copy) NSString *transactionID; //TODO get rid of me in favor of PPH class
@property (nonatomic, copy) NSMutableDictionary *shoppingCart;
@property (nonatomic, assign) PPHTransactionResponse *transactionResponse;

-(NSString*)getTotalString;
-(void)updateInvoiceWithTransactionRecord:(PPHTransactionRecord *)record;

@end
