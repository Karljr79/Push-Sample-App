//
//  Invoice.m
//  PushSampleApp
//
//  Created by Hirschhorn Jr, Karl on 5/30/14.
//  Copyright (c) 2014 OtherLevels. All rights reserved.
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

@end
