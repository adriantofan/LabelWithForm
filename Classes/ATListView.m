//
//  ATListView.m
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATListView.h"
#import "ATLineContainer.h"
#import "Layout.h"

@implementation ATListView
@synthesize lines = lines_, lineHeight = lineHeight_;


-(id)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];
    //    self.backgroundColor =[UIColor redColor];
    lineHeight_ = kCellRowHeight;
  }
  return self;
}

-(void)setFrame:(CGRect)frame{
  CGRect initialFrame = self.frame;
  [super setFrame:frame];
  // if we need to resize
  if (initialFrame.size.width != frame.size.width) {
    for (NSInteger k = 0; k < [self.lines count]; k++) {
      ATLineContainer *line = [lines_ objectAtIndex:k];
      CGRect lineFrame = [self layoutRectForLine:k];
      [line layoutSubviewsInRect:lineFrame];
    }
  }
}
#pragma mark - Query by line

-(NSInteger)lineIndexForView:(UIView*)view{
  CGRect viewFrame = view.frame;
  return (NSInteger)(viewFrame.origin.y / self.lineHeight);
}

// Returns a line container that contains the controll having tag or nil if not found
-(ATLineContainer*)lineOfControlHavingTag:(NSInteger)tag{
  UIView* subview = [self viewWithTag:tag];
  if (!subview) return nil;
  NSInteger index = [self lineIndexForView:subview];
  return [lines_ objectAtIndex:index];
}

-(CGRect)layoutRectForLine:(NSInteger)lineNumber{
  CGRect frame = self.frame;
  return CGRectMake(0.0,lineNumber * self.lineHeight, frame.size.width , self.lineHeight);
}

// for instant relooads everything
-(void)setLines:(NSArray*)lines{
  for (ATLineContainer* line in lines_) {
    for (UIView *subview in line.views) {
      [subview removeFromSuperview];
    }
  }
  lines_ = [lines copy];
  for (NSInteger k=0; k < [self.lines count]; k++) {
    ATLineContainer* line = [lines_ objectAtIndex:k];
    CGRect layoutFrame = [self layoutRectForLine:k];
    [line layoutSubviewsInRect:layoutFrame ];
    for (UIView *subview in line.views) {
      [self addSubview:subview];
    }
  }
}


#pragma mark - Change management

-(void)deleteLineAtIndex:(NSInteger)index animated:(BOOL)animated{
  if ((index < 0) || (index > [lines_ count])) return;
  ATLineContainer *line= [lines_ objectAtIndex:index];
  for (UIView * viewToHide in [line views]) { // put the line to delete in the back
    [self sendSubviewToBack:viewToHide];
  }
  NSTimeInterval duration = animated?0.3:0;
  [UIView animateWithDuration:duration
                   animations:^{
                     CGRect frame;
                     for (UIView * viewToHide in [line views]) { // make it invisible
                       viewToHide.alpha = 0.0;
                     }
                      for (NSInteger k = index + 1; k < [lines_ count]; k++) {
                        ATLineContainer* lineToSlide  = [lines_ objectAtIndex:k];
                        for (UIView * viewToSlide in [lineToSlide views]) {
                          frame = [viewToSlide frame];
                          frame.origin.y -= self.lineHeight;
                          viewToSlide.frame = frame;
                        }
                      }
                   }
                   completion:^(BOOL finished){
                     NSMutableArray *newLines = [NSMutableArray arrayWithArray:lines_];
                     [newLines removeObjectAtIndex:index];
                     lines_ = [NSArray arrayWithArray:newLines];
                     for (UIView * viewToRemove in [line views]) { // remove it from superview
                       [viewToRemove removeFromSuperview];
                     }
                   }];
}

-(void)insertLine:(ATLineContainer*)line atIndex:(NSInteger)index animated:(BOOL)animated{
  if ((index < 0) || (index > [lines_ count])) return;
  CGRect lineArea = [self layoutRectForLine:index - 1]; // move from up to down
  NSTimeInterval duration = animated?0.3:0;
  [line layoutSubviewsInRect:lineArea];
  [UIView animateWithDuration:duration animations:^{
    CGRect frame;
    for (UIView *view in [line views]) {
      [self addSubview:view];
    } // add
    NSMutableArray *newLines = [NSMutableArray arrayWithArray:lines_];
    [newLines insertObject:line atIndex:index];
    lines_ = [NSArray arrayWithArray:newLines];
    for (NSInteger k = index; k < [lines_ count]; k++) { // slide everyhing down
      ATLineContainer* lineToSlide  = [lines_ objectAtIndex:k];
      for (UIView * viewToSlide in [lineToSlide views]) {
        frame = [viewToSlide frame];
        frame.origin.y += self.lineHeight;
        viewToSlide.frame = frame;
      }
    }
  }];
}

@end

