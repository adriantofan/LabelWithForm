//
//  ATVerticalSeparator.m
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATVerticalSeparator.h"


@implementation ATVerticalSeparator


-(id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    [self addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vertical_separator"]]];
  }
  return self;
}
@end
