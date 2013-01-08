//
//  ATAddressCell.m
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATAddressCell.h"
#import "ATListViewTextFieldControler.h"
#import "ATTextFieldLineContainer.h"
#import "ATTwoTextFieldsLineContainer.h"
#import "ATListView.h"

enum {kFirstName, kLastName, kAddressLine, kPostalCode, kCity, kState, kCountry};

@implementation ATAddressCell
// 1
-(ATListViewTextFieldControler*) textFieldController{
  BOOL needsSetup = textFieldController_ == nil;
  [super textFieldController];
  if (needsSetup) {
    ATListViewTextFieldControler __weak * controller = textFieldController_;
    textFieldController_.lineContainerFactory = ^(){
      ATTextFieldLineContainer* line = [[ATTextFieldLineContainer alloc] init];
      line.textField.tag = kAddressLine;
      line.textField.delegate = controller;
      line.textField.placeholder = NSLocalizedString(@"Address", @"Address");
      return line;
    };
  }
  return textFieldController_;
}
// 2
-(NSString*) summaryText{
  return @"some address \n with description";
}

// 3
-(void)setContent:(NSDictionary*)content {
  textFieldController_ = nil;
  NSArray* addressLines = [content objectForKey:@(kAddressLine)];
  NSString *firstLine = [addressLines objectAtIndex:0];
  ATTextFieldLineContainer* address1 = [[ATTextFieldLineContainer alloc] init];
  ATTwoTextFieldsLineContainer* cityState = [[ATTwoTextFieldsLineContainer alloc] init];
  ATTwoTextFieldsLineContainer* zipCountry = [[ATTwoTextFieldsLineContainer alloc] init];
  
  self.textFieldController.dynamicTag = kAddressLine;
  self.textFieldController.dynamicRange = NSMakeRange(0,1);
  
  address1.textField.text = firstLine;
  address1.textField.placeholder = NSLocalizedString(@"Address", @"Address");
  address1.textField.tag = kAddressLine;
  address1.textField.delegate = self.textFieldController;
  cityState.textFieldOne.text = [content objectForKey:@(kCity)];
  cityState.textFieldOne.placeholder = NSLocalizedString(@"City", @"City");
  cityState.textFieldOne.tag = kCity;
  cityState.textFieldOne.delegate = self.textFieldController;
  cityState.textFieldTwo.text = [content objectForKey:@(kState)];
  cityState.textFieldTwo.placeholder = NSLocalizedString(@"State", @"State");
  cityState.textFieldTwo.tag = kState;
  cityState.textFieldTwo.delegate = self.textFieldController;
  zipCountry.textFieldOne.text = [content objectForKey:@(kPostalCode)];
  zipCountry.textFieldOne.placeholder = NSLocalizedString(@"Postal Code", @"Postal Code");
  zipCountry.textFieldOne.tag = kPostalCode;
  zipCountry.textFieldOne.delegate = self.textFieldController;
  zipCountry.textFieldTwo.text = [content objectForKey:@(kCountry)];
  zipCountry.textFieldTwo.placeholder = NSLocalizedString(@"Country", @"Country");
  zipCountry.textFieldTwo.tag = kCountry;
  zipCountry.textFieldTwo.delegate = self.textFieldController;

  [self.listView setLines:@[address1,cityState,zipCountry]];
  [super setContent:content]; // calls supper at the end in order to prepare context
}





@end
