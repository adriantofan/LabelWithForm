//
//  ATLineContainer.m
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATLineContainer.h"
#import "ATHorizontalSeparator.h"

@implementation ATLineContainer

@synthesize views = views_,layoutRect = layoutRect_, separator = separator_;
// returns only the UIControls from it's managed views
-(NSArray*) controls{
  return  [self.views  filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    return [evaluatedObject isKindOfClass:[UIControl class]];
  }]];
}

// it simply returns the layout's size as it always fits the asked size
+(CGSize)sizeForLayoutRect:(CGRect)layout{
  return layout.size;
}

// Saves layoutRect_, subclasses should relayout
-(void)layoutSubviewsInRect:(CGRect) layoutRect{
  layoutRect_ = layoutRect;
  CGRect frame = CGRectMake(0.0, layoutRect.origin.y + layoutRect.size.height - 0.5, layoutRect.size.width, 0.5);
  self.separator.frame = frame;
}
-(ATHorizontalSeparator*)separator{
  if (!separator_) {
    ATHorizontalSeparator *separator = [[ATHorizontalSeparator alloc] init];
    separator_ = separator;
  }
  return separator_;
}
@end

