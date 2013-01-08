//
//  ATListViewTextFieldControler.h
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ATListViewTextFieldControler,ATLineContainer;


typedef enum{
  ATListViewTextFieldControlerDelegateAddChange,
  ATListViewTextFieldControlerDelegateDeleteChange,
  ATListViewTextFieldControlerDelegateUpdateChange,
} ATListViewTextFieldControlerDelegateChange;

@protocol ATListViewTextFieldControlerDelegate <NSObject>

-(void)textFieldControler:(ATListViewTextFieldControler*)controller
            commitEditing:(ATListViewTextFieldControlerDelegateChange)change
                textField:(UITextField*)textField
                  oldText:(NSString*)oldText
                  newText:(NSString*)newText;

@end

@class ATListView;

@interface ATListViewTextFieldControler : NSObject<UITextFieldDelegate>

// All the propertyes should be readonly

// The listView container
@property (nonatomic,weak) ATListView* listView;

// The delegate to be informed of changes
@property (nonatomic,weak) id <ATListViewTextFieldControlerDelegate> delegate;

// Context set by user at creation accesible to delegate by convention between setter and delegate
// The context is not used by the controler it is intendend for delegate's use
@property (nonatomic,weak) NSObject* context;

// Holds the range of lines containing textfields with |dynamicTag| that auto-grow automaticaly
@property (nonatomic) NSRange dynamicRange;

// the tag of the UITextFields that are in the |dynamicRange|
@property (nonatomic) NSInteger dynamicTag;


// Set this to a factory block retrning properly initialized new lines to be used
// in the dynamic section of the torm
@property (nonatomic,copy) ATLineContainer* (^lineContainerFactory)();

// Sets the content for the UITextField coresponding at key
-(void)setText:(NSString*)text forKey:(NSInteger)key;
// Sets the content for the UITextField coresponding at key with |index| in the dynamic range
-(void)setText:(NSString*)text forIndexInDynamicList:(NSInteger)index;
// Inserts new line with |text| in the dynamic range at index
-(void)insertLineWithText:(NSString*) text atIndexInDynamicList:(NSInteger)index animated:(BOOL)animated;

@end
