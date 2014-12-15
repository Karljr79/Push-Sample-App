//
//  Tab3ViewController.h
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TagsViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>;
- (IBAction)textFieldAction:(id)sender;
- (IBAction)btnSetCustomTag:(id)sender;
- (IBAction)btnGetTag:(id)sender;
- (void)pickerDoneClicked;
- (void)viewTapped:(UITapGestureRecognizer *)tgr;
@property (strong, nonatomic) IBOutlet UITextField *txtTagName;
@property (strong, nonatomic) IBOutlet UITextField *txtTagValue;
@property (strong, nonatomic) IBOutlet UITextField *txtTagDataType;
@property (strong, nonatomic) IBOutlet UITextField *txtTagGetName;
@property (strong, nonatomic)          NSArray *tagDataArray;


@end
