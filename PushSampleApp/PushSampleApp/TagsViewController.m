//
//  TabViewController.m
//  PushSampleApp
//
//  Created by Karl Hirschhorn on 2/5/14.
//  Copyright (c) 2014 Sample App. All rights reserved.
//

#import "TagsViewController.h"

@interface TagsViewController ()

@end

@implementation TagsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set up array of tag types
    self.tagDataArray = [[NSArray alloc]initWithObjects:@"string", @"double", @"timestamp", nil];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.view addGestureRecognizer:tgr]; // or [self.view addGestureRecognizer:tgr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldAction:(id)sender {
    
    //create UIPicker when text field is tapped
    UIPickerView *tagDataPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [UIPickerView setAnimationDelegate:self];
    tagDataPicker.delegate = self;
    tagDataPicker.dataSource = self;
    [tagDataPicker setShowsSelectionIndicator:YES];
    _txtTagDataType.inputView = tagDataPicker;
    
    //add a done button to the picker view
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc]init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(pickerDoneClicked)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    _txtTagDataType.inputAccessoryView = keyboardDoneButtonView;
}

- (IBAction)btnSetCustomTag:(id)sender {
    //first check if values were entered into the fields
    if (_txtTagName.text.length == 0 || _txtTagValue == 0 || _txtTagDataType == 0)
    {
        // show alert
        NSString* messageString = [NSString stringWithFormat: @"You have not filled in all fields"];
        UIAlertView *alertID = [[UIAlertView alloc]
                                initWithTitle:@"Sample App"
                                message:messageString  delegate:self
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil];
        [alertID show];
    }
    else{
        NSString *currentUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"trackingID"];
        //Now we will take the currently registered tracking ID and set the specified tag value
        if (currentUserID.length >= 1)
        {
            //[mySDK setTagValue:currentUserID :_txtTagName.text :_txtTagValue.text :_txtTagDataType.text];
        }
    }
}

- (IBAction)btnGetTag:(id)sender {
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)windPicker {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)typePicker numberOfRowsInComponent:(NSInteger)component {
    return [self.tagDataArray count];
}

- (NSString *)pickerView:(UIPickerView *)typePicker titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return [self.tagDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)typePicker didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
        [_txtTagDataType setText:(NSString *)[self.tagDataArray objectAtIndex:row]];
}

- (void)pickerDoneClicked{
    [_txtTagDataType resignFirstResponder];
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    CGRect framer = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
    [UIView animateWithDuration:0.4f animations:^{
        self.view.frame = framer;}];
    [_txtTagName resignFirstResponder];
    [_txtTagValue resignFirstResponder];
    [_txtTagDataType resignFirstResponder];
    [_txtTagGetName resignFirstResponder];
}

@end
