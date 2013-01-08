//
//  ATTwoTextFieldsLineContainer.h
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATLineContainer.h"
@class ATVerticalSeparator;

@interface ATTwoTextFieldsLineContainer : ATLineContainer
@property (nonatomic)  UITextField *textFieldOne;
@property (nonatomic)  UITextField *textFieldTwo;
@property (nonatomic)  ATVerticalSeparator* fieldSeparator;
@end
