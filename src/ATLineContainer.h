//
//  ATLineContainer.h
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATHorizontalSeparator;

@interface ATLineContainer : NSObject{
  NSArray* views_;
  CGRect layoutRect_;
}
// Given a layout rect it comutes a size that would fit it's content
+(CGSize)sizeForLayoutRect:(CGRect)layout;

// Returns an array with all the views it manages
@property (nonatomic,readonly) NSArray* views;
// Returns an array of controls that it manages
@property (nonatomic,readonly) NSArray* controls;
// Tha layout rect that contains all of it's elements
@property (nonatomic,readonly) CGRect layoutRect;

@property (nonatomic,readonly) ATHorizontalSeparator* separator;

// Given a layoutRect it will layout it's subviews to fit and store the ne layoutRect
-(void)layoutSubviewsInRect:(CGRect) layoutRect;

@end
