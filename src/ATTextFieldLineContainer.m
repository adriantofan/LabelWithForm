//
//  ATTextFieldLineContainer.m
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATTextFieldLineContainer.h"
#import "Layout.h"
@implementation ATTextFieldLineContainer

@synthesize textField = textField_;

-(UITextField*)textField{
  if (!textField_) {
    textField_ = [[UITextField alloc] initWithFrame:CGRectZero];
    //textField_.backgroundColor = [UIColor redColor];
  }
  return textField_;
}

-(NSArray*) views{
  if (!views_) {
    views_ = @[self.textField,self.separator];
  }
  return views_;
}
-(void)layoutSubviewsInRect:(CGRect) layoutRect{
  [super layoutSubviewsInRect:layoutRect];
  CGRect frame = CGRectMake(kEdgeSpacerWidth, layoutRect.origin.y + 12.0, layoutRect.size.width - kEdgeSpacerWidth - kEdgeSpacerWidth, 21.0);
  self.textField.frame = frame;
}

@end

