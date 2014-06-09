//
//  Invoice.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 PayPal. All rights reserved.
//

#import "Invoice.h"

#define kBURGERS		@"Burgers"
#define kFRIES          @"Fries"
#define kSHAKES         @"Shakes"
#define kPIES           @"Pies"
#define kPRICE			@"Price"
#define kQUANTITY		@"Quantity"

@implementation Invoice

-(id)init{
    if((self = [super init])){
        
    // Custom initialization
    self.transactionID = @"No ID Yet";
        
    self.shoppingCart =
    [NSMutableDictionary
     dictionaryWithObjectsAndKeys:
     
     [NSMutableDictionary
      dictionaryWithObjectsAndKeys:
      [NSDecimalNumber numberWithDouble:5.95], kPRICE,
      [NSDecimalNumber numberWithInt:0], kQUANTITY,
      nil],
     kBURGERS,
     
     [NSMutableDictionary
      dictionaryWithObjectsAndKeys:
      [NSDecimalNumber numberWithDouble:2.99], kPRICE,
      [NSDecimalNumber numberWithInt:0], kQUANTITY,
      nil],
     kFRIES,
     
     [NSMutableDictionary
      dictionaryWithObjectsAndKeys:
      [NSDecimalNumber numberWithDouble:4.79], kPRICE,
      [NSDecimalNumber numberWithInt:0], kQUANTITY,
      nil],
     kSHAKES,
     
     [NSMutableDictionary
      dictionaryWithObjectsAndKeys:
      [NSDecimalNumber numberWithDouble:2.49], kPRICE,
      [NSDecimalNumber numberWithInt:0], kQUANTITY,
      nil],
     kPIES,
     
     nil];
    }
    return self;
}

//helper function to get the amount as a string with dollar sign appended
-(NSString*)getTotalString
{
    NSNumberFormatter* nf = [[NSNumberFormatter alloc]init];
    [nf setMinimumFractionDigits:2];
    [nf setMaximumFractionDigits:2];
   
    //format string and add dollar sign
    NSString *amtString = [NSString stringWithFormat:@"$%@",[nf stringFromNumber:self.totalAmount]];
    
    return amtString;
}

-(void)updateInvoiceWithTransactionRecord:(PPHTransactionRecord *)record
{
    self.transactionRecord = record;
    self.transactionID = record.transactionId;
}

@end
