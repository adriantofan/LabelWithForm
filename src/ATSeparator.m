//
//  ATSeparator.m
//  Test
//
//  Created by Adrian Tofan on 14/12/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import "ATSeparator.h"
#pragma mark - ATSeparator
@implementation ATSeparator
-(void)setFrame:(CGRect)frame{
  [super setFrame:frame];
  if ([[self subviews] count]) {
    [[[self subviews] objectAtIndex:0] setFrame:self.bounds];
  }
}
@end                                              


