//
//  ATListView.h
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATLineContainer;
@interface ATListView : UIView

// Given an array of ATLineContainer s loads them and displays them in the given order

-(void)setLines:(NSArray*)lines;
-(CGRect)layoutRectForLine:(NSInteger)lineNumber;

@property (nonatomic,assign) float lineHeight;
@property (nonatomic,readonly)  NSArray *lines;

// Returns the index or the row conaining the origin of view's frame
-(NSInteger)lineIndexForView:(UIView*)view;
-(void)insertLine:(ATLineContainer*)line atIndex:(NSInteger)index animated:(BOOL)animated;
-(void)deleteLineAtIndex:(NSInteger)index animated:(BOOL)animated;

// Returns a line container that contains the controll having tag or nil if not found
-(ATLineContainer*)lineOfControlHavingTag:(NSInteger)tag;

@end
