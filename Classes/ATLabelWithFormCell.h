//
//  ATFlexiCell.h
//  Test
//
//  Created by Adrian Tofan on 26/12/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ATListView,ATListViewTextFieldControler;
@protocol  ATListViewTextFieldControlerDelegate;

@interface ATLabelWithFormCell : UITableViewCell {
  @protected
  ATListViewTextFieldControler* textFieldController_;
}
@property ATListView *listView;
// Cell's label
@property (nonatomic,readonly) UILabel *label;

// Summary text - subclasess should implement this
@property (nonatomic) NSString *summaryText;

@property (nonatomic,readonly) ATListViewTextFieldControler* textFieldController;


// sets up the ATListViewTextFieldControlerDelegate's context to be self
@property (nonatomic,weak) id <ATListViewTextFieldControlerDelegate> textFieldControllerDelegate;

+(CGFloat)cellHeigh:(BOOL)editing contentWidth:(float)contentWidth  withText:(NSString*)text rowCount:(NSInteger)rowCount;
// Reload content in block
-(void)setContent:(NSDictionary*)content;
@property(nonatomic,retain) UIColor *summaryLabelColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,retain) UIColor *labelColor UI_APPEARANCE_SELECTOR;
@property(nonatomic,retain) UIColor *bgCollor UI_APPEARANCE_SELECTOR;

@end
