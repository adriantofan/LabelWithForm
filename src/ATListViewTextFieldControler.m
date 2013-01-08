//
//  ATListViewTextFieldControler.m
//  Test
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATListViewTextFieldControler.h"
#import "ATListView.h"
#import "ATLineContainer.h"
#import "ATTextFieldLineContainer.h"


@interface ATListViewTextFieldControler ()

-(ATLineContainer*)createNewDynamicLine;

@end
@implementation ATListViewTextFieldControler
@synthesize listView = listView_, delegate = delegate_, context = context_, dynamicRange = dynamicRange_, dynamicTag = dynamicTag_ ;
@synthesize lineContainerFactory = lineContainerFactory_;
#pragma mark - Helpers

-(ATLineContainer*)lineAtIndex:(NSInteger)index{
  NSArray *lines = [self.listView lines];
  if (index < [lines count]) {
    return [[self.listView lines] objectAtIndex:index];
  }
  return nil;
}

#pragma mark - Content Management

-(void)setText:(NSString*)text forKey:(NSInteger)key{
  ATLineContainer* line = [self.listView lineOfControlHavingTag:key];
  for (UITextField *field in line.controls) {
    if ([field isKindOfClass:[UITextField class]] &&
        (field.tag == key)){
      field.text = text;
      return;
    }
  }
}

-(void)setText:(NSString*)text forIndexInDynamicList:(NSInteger)index{
  ATTextFieldLineContainer * line =  (ATTextFieldLineContainer *)[self lineAtIndex:index];
  if ([line isKindOfClass:[ATTextFieldLineContainer class]]) {
    line.textField.text = text;
  }
}

-(void)insertLineWithText:(NSString*) text atIndexInDynamicList:(NSInteger)index animated:(BOOL)animated{
  if (index <= NSMaxRange(dynamicRange_)){
    ATTextFieldLineContainer * lineContainer = (ATTextFieldLineContainer*)[self createNewDynamicLine];
    lineContainer.textField.text = text;
    [self.listView insertLine:lineContainer atIndex:index  animated:animated];
    dynamicRange_.length += 1;
  }
}


#pragma mark - UITextFieldDelegate
// TODO: -> this doesen't allow styling only by subclassing of line ... is it as bad as that?
-(ATLineContainer*)createNewDynamicLine{
  if (lineContainerFactory_) {
    return lineContainerFactory_();
  }
  return  nil;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  NSInteger index = [self.listView lineIndexForView:textField];
  if([textField.text isEqualToString:@""] && // line is empty
     (dynamicRange_.length > 2) && // there are at least two lines in dynamic range
     NSLocationInRange(index,dynamicRange_) && // and the line is dynamic
     ((NSMaxRange(dynamicRange_) -1)!= index ) // it is not the last one in list 
     ){
    [self.listView deleteLineAtIndex:index animated:YES];
    dynamicRange_.length -= 1;
    if ([delegate_ respondsToSelector:@selector(textFieldControler:commitEditing:textField:oldText:newText:)]) {
      [self.delegate textFieldControler:self
                          commitEditing:ATListViewTextFieldControlerDelegateDeleteChange
                              textField:textField
                                oldText:textField.text
                                newText:textField.text];

    }
  }
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  NSString *oldText = textField.text;
  NSMutableString *newText = [textField.text mutableCopy];
  [newText replaceCharactersInRange:range withString:string];
  NSInteger lineIndex = [self.listView lineIndexForView:textField];
  BOOL delegateRecievesChanges = [self.delegate respondsToSelector:@selector(textFieldControler:commitEditing:textField:oldText:newText:)];
  
  if (delegateRecievesChanges) {
    [self.delegate textFieldControler:self
                        commitEditing:ATListViewTextFieldControlerDelegateUpdateChange
                            textField:textField
                              oldText:oldText
                              newText:newText];
  }
  if (NSLocationInRange(lineIndex,self.dynamicRange)) { // we are in the dynamic range
    if([newText length] && ([oldText length] == 0)){ // some text from no text
      if ((NSMaxRange(dynamicRange_) - lineIndex) == 1 ){ // it is the last dynamic field
        [self insertLineWithText:@"" atIndexInDynamicList:(lineIndex + 1) animated:YES];
        [self.delegate textFieldControler:self
                            commitEditing:ATListViewTextFieldControlerDelegateAddChange
                                textField:textField
                                  oldText:oldText
                                  newText:newText];
      }
    }
  }
  return YES;
}
@end
