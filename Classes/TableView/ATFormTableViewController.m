//
//  ATFormTableViewController.m
//  LabelWithForm
//
//  Created by Adrian Tofan on 09/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATFormTableViewController.h"
#import "ATListViewTextFieldControler.h"
#import "UITableViewCell+athelper.h"

@interface ATFormTableViewController (){
  NSMutableDictionary* editingStyles_;
  NSMutableDictionary* addVisibility_;
  // saved temporary when the cell self.editing cell is reused
  // indexPathForCell:self.editing cell returns nil so this index path can be used instead
  NSIndexPath* tempEditingCellIndexPath_;
}

@end

@implementation ATFormTableViewController
@synthesize editingCell = editingCell_;

#pragma mark - Table View Helpers

-(void)updateTableViewCellHeights{
  [self.tableView beginUpdates];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  editingStyles_ = [[NSMutableDictionary alloc] initWithCapacity:20];
  self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Model 
-(NSInteger)emptyModelLineCountInSection:(NSInteger)section{
  NSInteger count = 0;
  for (int k = 0; k < [self numberOfModelsInSection:section]; k++) {
    if ([self isEmptyModelAtIndexPath:[NSIndexPath indexPathForRow:k inSection:section]])count++;
  }
  return  count;
}

- (BOOL) isEmptyModelAtIndexPath:(NSIndexPath*)indexPath{
  NSAssert(NO, @"Subclasses need to overwrite this method");
  return NO;
}
- (NSInteger) numberOfModelsInSection:(NSInteger)section{
  NSAssert(NO, @"Subclasses need to overwrite this method");
  return 0;
}
- (void) insertEmptyModelAtIndexPath:(NSIndexPath*)indexPath{
  NSAssert(NO, @"Subclasses need to overwrite this method");
}
- (void) deleteModelsAtIndexPaths:(NSArray*)indexPaths{
  NSAssert(NO, @"Subclasses need to overwrite this method");
}
- (void) deleteModelAtIndexPath:(NSIndexPath*)indexPath{
  NSAssert(NO, @"Subclasses need to overwrite this method");
}



#pragma mark - Edit management

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
  [super setEditing:editing animated:animated];
  tempEditingCellIndexPath_ = nil;
  if (editing) {
    editingCell_ = nil;
    [self resetAllAddButtonsVisibility];
  }else{
  }
}

-(void)setEditingCell:(UITableViewCell *)editingCell{
  NSIndexPath* oldIndexPath = [self.tableView indexPathForCell:editingCell_];
  NSIndexPath* newIndexPath = [self.tableView indexPathForCell:editingCell];
  if (editingCell == nil) { editingCell_ = nil; return;}
  if (!editingCell_) {
    editingCell_ = editingCell;
    [self editingInProgressAtIndexPath:newIndexPath];
    return;
  }
  if (![oldIndexPath isEqual:newIndexPath]) {
    if (oldIndexPath == nil ) {
      oldIndexPath = tempEditingCellIndexPath_;
    }
    [self editingDidEndedAtIndexPath:oldIndexPath];
  }
  editingCell_ = editingCell;
  [self editingInProgressAtIndexPath:newIndexPath];
}


-(void)configureSectionForEditing:(NSInteger)section{
  ATSectionEditingStyle style = [self editingStyleForSection:section];
  NSInteger modelCount = [self numberOfModelsInSection:section];
  
  if (style & ATSectionEditingStyleList &&( // it is a list and
       (modelCount > 0) ||                       // it has some elements
       (style & ATSectionEditingStyleNeverEmpty) // or it must have elements
       )){ // add a empty element in the model and in the tableView
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:modelCount inSection:section];
    [self insertEmptyModelAtIndexPath:(NSIndexPath*)indexPath];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  if (style & ATSectionEditingStyleListWithAddButton &&( //a list with Add and
        ((modelCount != 0) ||                      // no elements
        (style & ATSectionEditingStyleNeverEmpty)) // and it it must have elements
        )){ // add a add button
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:modelCount inSection:section];
    [self setAddButonVisible:YES inSection:section];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  if (style & ATSectionEditingStyleStaticOnlyEdit) {
    [self configureStaticSectionForEditing:section];
  }
}


-(void)configureSectionForEndingEditing:(NSInteger)section{
  ATSectionEditingStyle style = [self editingStyleForSection:section];
  NSInteger modelCount = [self numberOfModelsInSection:section];
  if ((style & ATSectionEditingStyleList)||
      (style & ATSectionEditingStyleListWithAddButton)){
    // Delete add button
    if ((style & ATSectionEditingStyleListWithAddButton) &&
        ([self isAddButonVisibleInSection:section])){
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:modelCount // it is the last button after models
                                                  inSection:section];
      [self setAddButonVisible:NO inSection:section];
      
      [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    // delete empty rows
    NSMutableArray *toDelete = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSInteger k = 0; k<modelCount; k++){
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:k inSection:section];
      if ([self isEmptyModelAtIndexPath:indexPath]){
        [toDelete addObject:indexPath];
      }
    }
    [self deleteModelsAtIndexPaths:toDelete];
    [self.tableView deleteRowsAtIndexPaths:toDelete withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  if (style & ATSectionEditingStyleStaticOnlyEdit) {
    [self configureStaticSectionForEngingEditing:section];
  }
}

-(void)configureStaticSectionForEditing:(NSInteger)section{
  
}

-(void)configureStaticSectionForEngingEditing:(NSInteger)section{
}
#pragma mark - Edit session

-(void)editingDidEndedAtIndexPath:(NSIndexPath*)indexPath{
  ATSectionEditingStyle style = [self editingStyleForSection:indexPath.section];
  if (!((style & ATSectionEditingStyleListWithAddButton) ||
        (style & ATSectionEditingStyleList ))){
    return;
  }
  //NSInteger modelCount = [self numberOfModelsInSection:indexPath.section];
  if (((style & ATSectionEditingStyleListWithAddButton) ||
      (style & ATSectionEditingStyleList)) &&
      [self isEmptyModelAtIndexPath:indexPath] &&
      ([self emptyModelLineCountInSection:indexPath.section] > 1)){
    [self.tableView beginUpdates];
    [self deleteModelAtIndexPath:indexPath];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
  }
}

-(void)editingInProgressAtIndexPath:(NSIndexPath*)indexPath{
  ATSectionEditingStyle style = [self editingStyleForSection:indexPath.section];
  NSInteger modelCount = [self numberOfModelsInSection:indexPath.section];
  if (!((style & ATSectionEditingStyleListWithAddButton) ||
      (style & ATSectionEditingStyleList ))){
    return;
  }
  if ((modelCount == (indexPath.row + 1)) &&
      (![self isEmptyModelAtIndexPath:indexPath])){// it is the last item in a editing list that becomed non empty
    if (style & ATSectionEditingStyleList) { // add one empty model at the end
      UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
      NSIndexPath *indexPathToAdd = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                       inSection:indexPath.section];
      [self insertEmptyModelAtIndexPath:indexPathToAdd];
      [self.tableView insertRowsAtIndexPaths:@[indexPathToAdd]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      [self.tableView endUpdates];
      [self updateEditingStyleForCell:cell atIndexPath:indexPath];
    }
    if ((style & ATSectionEditingStyleListWithAddButton) &&
        ![self isAddButonVisibleInSection:indexPath.section]) { // add the Add cell at the end
      NSIndexPath *indexPathToAdd = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                       inSection:indexPath.section];
      [self.tableView beginUpdates];
      [self setAddButonVisible:YES inSection:indexPath.section];
      [self.tableView insertRowsAtIndexPaths:@[indexPathToAdd]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      [self.tableView endUpdates];
    }
  }
}

#pragma mark - Add buttons for dynamic sections
- (BOOL) isAddButonAtIndexPath:(NSIndexPath*)indexPath{
  if (![self isAddButonVisibleInSection:indexPath.section]) {
    return NO;
  }
  return indexPath.row == [self numberOfModelsInSection:indexPath.section];
}

- (BOOL) isAddButonVisibleInSection:(NSInteger)section{
  NSNumber *visibility = [addVisibility_ objectForKey:@(section)];
  return visibility  ? [visibility boolValue] : NO;
}
- (void) setAddButonVisible:(BOOL)visible inSection:(NSInteger)section{
  [addVisibility_ setObject:[NSNumber numberWithBool:visible]
                     forKey:@(section)];
}
- (void) resetAllAddButtonsVisibility{
  addVisibility_ = [[NSMutableDictionary alloc] initWithCapacity:20];
}


#pragma mark - SectionEditingStyle
- (void) setEditingStyle:(ATSectionEditingStyle)style
              forSection:(NSInteger)section{
  [editingStyles_ setObject:[NSNumber numberWithInteger:style]
                     forKey:@(section)];
}
- (ATSectionEditingStyle)editingStyleForSection:(NSInteger)section{
  NSNumber *style = [editingStyles_ objectForKey:@(section)];
  return style? [style integerValue] : ATSectionEditingStyleNotSet;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  [self.tableView beginUpdates];
  if (editingStyle ==  UITableViewCellEditingStyleInsert) {
    [self insertEmptyModelAtIndexPath:indexPath];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
  if (editingStyle ==  UITableViewCellEditingStyleDelete) {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell == editingCell_ ){
      editingCell_ = nil;
      tempEditingCellIndexPath_ = nil;
    }
    [cell endEditing:YES];
    [self deleteModelAtIndexPath:indexPath];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    ATSectionEditingStyle style = [self editingStyleForSection:indexPath.section];

    if (style & ATSectionEditingStyleListWithAddButton) {
      if (![self isAddButonVisibleInSection:indexPath.section] &&
          ![self emptyModelLineCountInSection:indexPath.section]) {
        [self setAddButonVisible:YES inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
      }
    }
  }

  [self.tableView endUpdates];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger modelCount = [self numberOfModelsInSection:section];
  if ([self isAddButonVisibleInSection:section]) {
    return modelCount + 1;
  }
  return modelCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}
#pragma mark - Table view delegate



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if ([self isAddButonAtIndexPath:indexPath]) {
    [self.tableView beginUpdates];
    [self setAddButonVisible:NO inSection:indexPath.section];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self insertEmptyModelAtIndexPath:indexPath];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
  }
}





-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  ATSectionEditingStyle style = [self editingStyleForSection:indexPath.section];
  if (style & ATSectionEditingStyleList){
    return UITableViewCellEditingStyleDelete;
  }
  if (style & ATSectionEditingStyleListWithAddButton){
    if (indexPath.row == [self numberOfModelsInSection:indexPath.section]&&
        [self isAddButonVisibleInSection:indexPath.section]) {// it is the add button
      return UITableViewCellEditingStyleInsert;
    }else{
      return UITableViewCellEditingStyleDelete;
    }
  }
  return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  [self updateEditingStyleForCell:cell atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  if (cell == editingCell_ ){
    tempEditingCellIndexPath_ = indexPath;
  }else{
  }
}

//TODO: move this in propper section
-(void)updateEditingStyleForCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*)indexPath{
  ATSectionEditingStyle style = [self editingStyleForSection:indexPath.section];
  if (style & ATSectionEditingStyleList){
    int modelCount = [self numberOfModelsInSection:indexPath.section];
    if ((indexPath.row == (modelCount - 1)) &&
        [self isEmptyModelAtIndexPath:indexPath]){
      cell.editView.hidden = YES;
    }
    if((style & ATSectionEditingStyleNeverEmpty) &&
          (indexPath.row == (modelCount - 1) == 1)){
      cell.editView.hidden = YES;
    }
    else{
      cell.editView.hidden = NO;
    }
  }  
}
#pragma mark - ATListViewTextFieldControlerDelegate protocol
-(void)textFieldControler:(ATListViewTextFieldControler*)controller
            commitEditing:(ATListViewTextFieldControlerDelegateChange)change
                textField:(UITextField*)textField
                  oldText:(NSString*)oldText
                  newText:(NSString*)newText
                     line:(NSInteger)line{
  NSAssert(NO, @"Subclasses need to overwrite this method");  
}

@end
