//
//  ATFlexiCell.m
//  Test
//
//  Created by Adrian Tofan on 26/12/12.
//  Copyright (c) 2012 Adrian Tofan. All rights reserved.
//
#import "Layout.h"
#import "ATLabelWithFormCell.h"
#import "ATSeparator.h"
#import "ATVerticalSeparator.h"
#import "ATListView.h"
#import "ATTextFieldLineContainer.h"
#import "ATTwoTextFieldsLineContainer.h"
#import "ATListViewTextFieldControler.h"


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define TextFieldFont [UIFont boldSystemFontOfSize:15.0]
#define LabelFont [UIFont systemFontOfSize:13.0]
#define SumaryLabelFont [UIFont boldSystemFontOfSize:15.0]

#define BackgroundCollor UIColorFromRGB(0xf7f7f7)
#define SumaryLabelColor [UIColor blackColor]
#define LabelColor [UIColor colorWithRed:0.32 green:0.4 blue:0.57 alpha:1.0]

#define kVerticalMargin 12.0
#define kVSeparatorWidth (IS_RETINA?0.5:1.0)

#define kVSeparatorWidth (IS_RETINA?0.5:1.0)
#define kVSeparatorHeight (IS_RETINA?0.5:1.0)
#define kVSeparatorX (kLabelX + kLabelWidth + kEdgeSpacerWidth)
#define kVSeparatorY 0.0

#define kLabelWidth 72.0
#define kLabelHeight 18.0
#define kLabelX kEdgeSpacerWidth
#define kLabelY 13.0

#define kEditFieldX 
#define kEditFieldY 12.0
#define kEditFieldHeight 21.0

#define kSummaryLabelX (kLabelX + kLabelWidth + kVSeparatorWidth + 2*kEdgeSpacerWidth)
#define kSummaryLabelY kLabelY


#pragma mark - utilities

CGRect sumaryLabelFrame1(NSString* text, float contentWidth){
  float width = contentWidth  - kEdgeSpacerWidth - 2* kEdgeSpacerWidth;
//  [text sizeWithFont:SumaryLabelFont
//   constrainedToSize:CGSizeMake(width,1000.0)
//       lineBreakMode:NSLineBreakByWordWrapping];
  CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(width,1000.0)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:SumaryLabelFont}
                                           context:nil];
  CGRect frame = CGRectMake(kSummaryLabelX,kSummaryLabelY,width,boundingRect.size.height);
  return frame;
}







#pragma mark - ATTextFieldLineContainer



#pragma mark - ATListView



@interface ATFlexiCellContentViewAddress:ATListView
@end
@implementation ATFlexiCellContentViewAddress
@end

@interface ATLabelWithFormCell (){
  

}
// The UILabel containing the summary of the content
@property (nonatomic,readonly) UILabel *summaryLabel;
@property (nonatomic) ATVerticalSeparator *verticalSeparator;


@end


#pragma mark - ATFlexiCell
@implementation ATLabelWithFormCell
@synthesize listView = listView_,summaryLabel = summaryLabel_,label = label_;
@synthesize verticalSeparator = verticalSeparator_;
@synthesize textFieldController = textFieldController_;
@synthesize textFieldControllerDelegate = textFieldControllerDelegate_;
@synthesize summaryLabelColor = summaryLabelColor_;
@synthesize labelColor = labelColor_;
@synthesize bgCollor = bgCollor_;

-(UIColor*)summaryLabelColor{
  if (nil == summaryLabelColor_ ) {
    summaryLabelColor_ = SumaryLabelColor;
  }
  return summaryLabelColor_;
}
-(UIColor*)labelColor{
  if (nil == labelColor_) {
    labelColor_ = LabelColor;
  }
  return labelColor_;
}
-(UIColor*)bgCollor{
  if (nil == bgCollor_) {
    bgCollor_ = BackgroundCollor;
  }
  return bgCollor_;
}

#pragma  mark - class methods

+(CGFloat)cellHeigh:(BOOL)editing contentWidth:(float)contentWidth  withText:(NSString*)text rowCount:(NSInteger)rowCount{
  if (editing) {
    return kCellRowHeight * rowCount;
  }else{
    CGRect f;
    f = sumaryLabelFrame1(text,contentWidth);
    return kLabelY + f.size.height + kLabelY;
  }
}

#pragma  mark - initializer 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      listView_ = [[ATListView alloc] initWithFrame:CGRectMake(kLabelX + kLabelWidth + kVSeparatorWidth + kEdgeSpacerWidth,0.0 ,0.0 ,0.0 )];
      [self.contentView addSubview:listView_];
      listView_.alpha = 0.0;
      [self.contentView addSubview:self.summaryLabel];
      [self.contentView addSubview:self.label];
      [self.contentView addSubview:self.verticalSeparator];
    }
    return self;
}

#pragma  mark - setters / getters

-(ATListViewTextFieldControler*) textFieldController{
  if (!textFieldController_) {  
    textFieldController_ = [[ATListViewTextFieldControler alloc] init];
    textFieldController_.listView = self.listView;
    textFieldController_.delegate = self.textFieldControllerDelegate;
    textFieldController_.context = self;
  }
  return textFieldController_;
}
-(void)didMoveToSuperview{
  [super didMoveToSuperview];
  self.summaryLabel.backgroundColor = self.bgCollor;
  self.summaryLabel.textColor = self.summaryLabelColor;
  self.label.backgroundColor = self.bgCollor;
  self.label.textColor = self.labelColor;
  
}

-(ATVerticalSeparator *)verticalSeparator{
  if (!verticalSeparator_) {
    ATVerticalSeparator *separator = [[ATVerticalSeparator alloc] initWithFrame:CGRectZero];
    CGRect frame = separator.frame;
    frame.origin.x = kVSeparatorX;
    frame.origin.y = kVSeparatorY;
    frame.size.width = kVSeparatorWidth;
    frame.size.height = kVSeparatorHeight;
    separator.frame = frame;
    verticalSeparator_ = separator;
  }
  return verticalSeparator_;
}

 
-(UILabel *)summaryLabel{
  if (!summaryLabel_) {
    CGRect labelFrame = sumaryLabelFrame1(self.summaryText, self.listView.frame.size.width);
    UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = SumaryLabelFont;
    label.numberOfLines = 10;
    summaryLabel_ = label;
  }
  return summaryLabel_;
}

-(UILabel *)label{
  if (!label_) {
    CGRect labelFrame = CGRectMake(kLabelX, kLabelY, kLabelWidth, kLabelHeight);
    UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = LabelFont;
    label.textAlignment = NSTextAlignmentRight;
    label_ = label;
  }
  return label_;
}

-(NSString*) summaryText{
  return @"";
}


-(void)setContent:(NSDictionary*)content {
  self.summaryLabel.frame = sumaryLabelFrame1(self.summaryText, self.listView.frame.size.width);
  self.summaryLabel.text = self.summaryText;
}

#pragma  mark - Frame related manipulations
-(void)updateLayout{
  CGRect formFrame = listView_.frame;
  formFrame.size.width = self.contentView.frame.size.width - formFrame.origin.x;
  formFrame.size.height = self.contentView.frame.size.height;
  [listView_ setFrame:formFrame];
  self.summaryLabel.frame = sumaryLabelFrame1(self.summaryText, self.listView.frame.size.width);
  CGRect separatorFrame = self.verticalSeparator.frame;
  separatorFrame.size.height = self.contentView.frame.size.height;
  self.verticalSeparator.frame = separatorFrame;
}
-(void)setFrame:(CGRect)frame{
  // seems to be set to no by the TableView
  self.contentView.clipsToBounds = YES;
  [super setFrame:frame];
  [self updateLayout];
}
-(void)layoutSubviews{
  [super layoutSubviews];
  [self updateLayout];
}


#pragma  mark - Cell lifecycle

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
  self.summaryLabel.text = self.summaryText;
  [super setEditing:editing animated:animated];
  float duration = animated ? 0.3 : -1.0;
  [UIView animateWithDuration:duration animations:^{
    if (editing) {
      self.summaryLabel.alpha = 0.0;
      self.listView.alpha = 1.0;
      self.verticalSeparator.alpha = 1.0;
    }else{
      self.summaryLabel.alpha = 1.0;
      self.listView.alpha = 0.0;
      self.verticalSeparator.alpha = 0.0;
      [self endEditing:YES];
    }
   }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
