//
//  ATTwoTextFieldsLineContainer.m
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATTwoTextFieldsLineContainer.h"
#import "ATVerticalSeparator.h"
#import "Layout.h"

@implementation ATTwoTextFieldsLineContainer
@synthesize textFieldOne = textFieldOne_, textFieldTwo = textFieldTwo_,
fieldSeparator = fieldSeparator_;
- (ATVerticalSeparator*) fieldSeparator{
  if (!fieldSeparator_) {
    fieldSeparator_ = [[ATVerticalSeparator alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.5, 1.0)];
  }
  return fieldSeparator_;
}
-(UITextField*)textFieldOne{
  if (!textFieldOne_) {
    textFieldOne_ = [[UITextField alloc] initWithFrame:CGRectZero];
    //    textFieldOne_.backgroundColor = [UIColor redColor];
  }
  return textFieldOne_;
}
-(UITextField*)textFieldTwo{
  if (!textFieldTwo_) {
    textFieldTwo_ = [[UITextField alloc] initWithFrame:CGRectZero];
    //    textFieldTwo_.backgroundColor = [UIColor redColor];
  }
  return textFieldTwo_;
}

-(NSArray*) views{
  if (!views_) {
    views_ = @[self.textFieldOne,self.textFieldTwo,self.separator,self.fieldSeparator];
  }
  return views_;
}
-(void)layoutSubviewsInRect:(CGRect) layoutRect{
  [super layoutSubviewsInRect:layoutRect];
  float fieldWidth = (layoutRect.size.width - self.fieldSeparator.frame.size.width - 4 *kEdgeSpacerWidth ) / 2.0 ;
  CGRect frame = CGRectMake(kEdgeSpacerWidth, layoutRect.origin.y + 12.0,fieldWidth , 21.0);
  self.textFieldOne.frame = frame;
  frame.origin.x += (2*kEdgeSpacerWidth + fieldWidth + self.fieldSeparator.frame.size.width) ;
  self.textFieldTwo.frame = frame;
  CGRect separatorFrame = CGRectMake(frame.origin.x - self.fieldSeparator.frame.size.width -kEdgeSpacerWidth , layoutRect.origin.y , 0.5, layoutRect.size.height);
  self.fieldSeparator.frame = separatorFrame;
}
@end

