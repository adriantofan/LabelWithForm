//
//  UITableViewCell+athelper.m
//  LabelWithForm
//
//  Created by Adrian Tofan on 22/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "UITableViewCell+athelper.h"

@implementation UITableViewCell (athelper)
-(UIView*)editView{
  for (UIView *subview in self.subviews) {
    if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) return subview;
  }
  return nil;
}
@end
