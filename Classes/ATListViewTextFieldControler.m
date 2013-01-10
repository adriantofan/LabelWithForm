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

// returns how many empty lines are in range
-(NSInteger) emptyLinesCountInRange:(NSRange)range;
@end

@implementation ATListViewTextFieldControler
@synthesize listView = listView_, delegate = delegate_, context = context_, dynamicRange = dynamicRange_, dynamicTag = dynamicTag_ ;
@synthesize lineContainerFactory = lineContainerFactory_;

#pragma mark - Helpers
-(NSInteger) emptyLinesCountInRange:(NSRange)range{
  NSInteger count = 0;
  ATTextFieldLineContainer * line;
  for (NSInteger k = range.location ; NSLocationInRange(k,range); k++) {
    line = [self.listView.lines objectAtIndex:k];
    if ([line.textField.text isEqualToString:@""]) count++;
  }
  return count;
}

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


// TODO: -> this doesen't allow styling only by subclassing of line ... is it as bad as that?
-(ATLineContainer*)createNewDynamicLine{
  if (lineContainerFactory_) {
    return lineContainerFactory_();
  }
  return  nil;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField*) textField{
  NSInteger index = [self.listView lineIndexForView:textField];
  if ([delegate_ respondsToSelector:@selector(textFieldControler:commitEditing:textField:oldText:newText:line:)]) {
    [self.delegate textFieldControler:self
                        commitEditing:ATListViewTextFieldControlerDelegateStartEditingLineChange
                            textField:textField
                              oldText:textField.text
                              newText:textField.text
                                 line:index];
    
  }

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
  NSInteger index = [self.listView lineIndexForView:textField];
  if([textField.text isEqualToString:@""] && // line is empty
     ([self emptyLinesCountInRange:self.dynamicRange] > 1) && // there are at least two lines in dynamic range
     NSLocationInRange(index,dynamicRange_)  // and the line is dynamic
     ){
    [self.listView deleteLineAtIndex:index animated:YES];
    dynamicRange_.length -= 1;
    if ([delegate_ respondsToSelector:@selector(textFieldControler:commitEditing:textField:oldText:newText:line:)]) {
      [self.delegate textFieldControler:self
                          commitEditing:ATListViewTextFieldControlerDelegateDeleteChange
                              textField:textField
                                oldText:textField.text
                                newText:textField.text
                                   line:index];
      
    }
  }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  NSString *oldText = textField.text;
  NSMutableString *newText = [textField.text mutableCopy];
  [newText replaceCharactersInRange:range withString:string];
  NSInteger lineIndex = [self.listView lineIndexForView:textField];
  BOOL delegateRecievesChanges = [self.delegate respondsToSelector:@selector(textFieldControler:commitEditing:textField:oldText:newText:line:)];
  
  if (delegateRecievesChanges) {
    [self.delegate textFieldControler:self
                        commitEditing:ATListViewTextFieldControlerDelegateUpdateChange
                            textField:textField
                              oldText:oldText
                              newText:newText
                                 line:lineIndex];
  }
  if (NSLocationInRange(lineIndex,self.dynamicRange)) { // we are in the dynamic range
    if([newText length] && ([oldText length] == 0)){ // some text from no text
      if ((NSMaxRange(dynamicRange_) - lineIndex) == 1 ){ // it is the last dynamic field
        [self insertLineWithText:@"" atIndexInDynamicList:(lineIndex + 1) animated:YES];
        if (delegateRecievesChanges){
          int64_t delayInSeconds = 0.0;
          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
          dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.delegate textFieldControler:self
                                commitEditing:ATListViewTextFieldControlerDelegateAddChange
                                    textField:textField
                                      oldText:@""
                                      newText:@""
                                         line:lineIndex + 1];
          });
        }
      }
    }
  }
  return YES;
}
@end
