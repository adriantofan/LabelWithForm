//
//  ATFullTableViewController.m
//  LabelWithForm
//
//  Created by Adrian Tofan on 09/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATFullTableViewController.h"
#import "ATListViewTextFieldControler.h"
#import "ATAddressCell.h"

#pragma mark - NSIndexPath extension

@interface NSIndexPath (ATEqualityAdditions)
- (BOOL)isEqual:(id)anObject;
@end
@implementation NSIndexPath (ATEqualityAdditions)

- (BOOL)isEqual:(id)anObject{
  NSIndexPath *other = anObject;
  if ((self.row == other.row) && (self.section == other.section)) {
    return YES;
  }
  return NO;
}
@end

#pragma mark - ATFullTableViewController private declarations 

@interface ATFullTableViewController (){
  NSArray* models_;
}
@end

#pragma mark - ATFullTableViewController implementation

@implementation ATFullTableViewController



- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  models_ = @[[NSMutableArray arrayWithCapacity:10],
              [NSMutableArray arrayWithObjects:[self emptyModel],nil],
              [NSMutableArray arrayWithCapacity:10],
              ];
  [self.tableView registerClass:[ATAddressCell  class] forCellReuseIdentifier:@"ATAddressCellId"];
  [self setEditingStyle: ATSectionEditingStyleNeverEmpty | ATSectionEditingStyleList
             forSection:0];
  [self setEditingStyle: ATSectionEditingStyleNeverEmpty | ATSectionEditingStyleListWithAddButton
             forSection:1];
  [self setEditingStyle: ATSectionEditingStyleStaticOnlyEdit
             forSection:2];
}
#pragma mark setters / getters

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
  [super setEditing:editing animated:animated];
  NSInteger sectionCount = [self numberOfSectionsInTableView:self.tableView];
  if (editing) {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [self.tableView beginUpdates];
    for (NSInteger k = 0; k < sectionCount; k++) {
      [self configureSectionForEditing:k];
    }
    [self.tableView endUpdates];
    self.tableView.editing = NO;
    self.tableView.editing = YES;
  }else{
    [self.tableView endEditing:YES];
    self.navigationItem.leftBarButtonItem = nil; // clear cancel button
    [self.tableView beginUpdates];
    for (NSInteger k = 0; k < sectionCount; k++) {
      [self configureSectionForEndingEditing:k];
    }
    [self.tableView endUpdates];

  }
}

#pragma mark - Button actions

-(IBAction)cancelPressed{
  // TODO: Cancel (somehow) edits
  self.navigationItem.leftBarButtonItem = nil;
  self.editing = NO;
  self.tableView.editing = NO;
  [self.tableView reloadData];
}

#pragma mark - model mock up
-(NSMutableDictionary*)emptyModel{
  NSDictionary* emptyModel = @{@(kAddressLine):[NSMutableArray arrayWithObject:@""],
  @(kCity):@"",
  @(kState):@"",
  @(kPostalCode):@"",
  @(kCountry):@"",
  };
  return [NSMutableDictionary dictionaryWithDictionary:emptyModel];
}
-(NSInteger)addressCountAtIndexPath:(NSIndexPath*)indexPath{
  NSMutableArray* modelArray = [models_ objectAtIndex:indexPath.section];
  NSMutableDictionary *model = [modelArray objectAtIndex:indexPath.row];
  return [[model objectForKey:@(kAddressLine)] count];
}

#pragma mark - methods from supper class

- (NSInteger) numberOfModelsInSection:(NSInteger)sectionPath{
  return [[models_ objectAtIndex:sectionPath] count];
}


- (void) insertEmptyModelAtIndexPath:(NSIndexPath*)indexPath{
  NSMutableArray* modelArray = [models_ objectAtIndex:indexPath.section];
  [modelArray insertObject:[self emptyModel] atIndex:indexPath.row];
}

- (BOOL) isEmptyModelAtIndexPath:(NSIndexPath*)indexPath{
  return [self addressCountAtIndexPath:indexPath] == 1;
}

- (void) deleteModelAtIndexPath:(NSIndexPath*)indexPath{
  NSMutableArray* modelArray = [models_ objectAtIndex:indexPath.section];
  [modelArray removeObjectAtIndex:indexPath.row];
}
- (void) deleteModelsAtIndexPaths:(NSArray*)indexPaths{
//  NSMutableSet *sections = [[NSMutableSet alloc] init];
  NSMutableDictionary *rowsBySection = [NSMutableDictionary dictionary];
  for (NSIndexPath *indexPath in indexPaths) {
    NSMutableArray * rows = [rowsBySection objectForKey:@(indexPath.section)];
    if (!rows) {
      rows = [NSMutableArray array];
      [rowsBySection setObject:rows  forKey:@(indexPath.section)];
    }
    [rows addObject:@(indexPath.row)];
  }
  for (NSNumber* section in [rowsBySection allKeys]) {
    NSMutableArray* modelArray = [models_ objectAtIndex:[section integerValue]];
    NSMutableIndexSet* toDelete = [NSMutableIndexSet indexSet];
    NSArray* items = [rowsBySection objectForKey:section];
    for (NSNumber *nr in items) {
      [toDelete addIndex:[nr integerValue]];
    }
    [modelArray removeObjectsAtIndexes:toDelete];
  }
}

-(void)configureStaticSectionForEngingEditing:(NSInteger)section{
  if (section == 2) {
    
  }
}
-(void)configureStaticSectionForEditing:(NSInteger)section{
  if (section == 2) {
    
  }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row >= [self numberOfModelsInSection:indexPath.section]) {
    UITableViewCell * addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ddd"];
    addCell.textLabel.text = @"add row";
    return addCell;
  }
  NSMutableArray* modelArray = [models_ objectAtIndex:indexPath.section];
  ATAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ATAddressCellId"];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textFieldControllerDelegate = self;
  [cell setContent:[modelArray objectAtIndex:indexPath.row]];
  cell.label.text = @"Address";
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  CGRect frame = self.tableView.frame;
  CGFloat width = frame.size.width - (self.isEditing?(20.0+30.0):20.0);
  if (indexPath.row < [self numberOfModelsInSection:indexPath.section]) {
    return [ATAddressCell cellHeigh:self.isEditing contentWidth:width  withText:@"some address \n with description" rowCount:2 + [self addressCountAtIndexPath:indexPath]];

  }
  return 44.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
  return YES;
}
#pragma mark - Table view delegate



#pragma mark - ATListViewTextFieldControlerDelegate

-(void)textFieldControler:(ATListViewTextFieldControler*)controller
            commitEditing:(ATListViewTextFieldControlerDelegateChange)change
                textField:(UITextField*)textField
                  oldText:(NSString*)oldText
                  newText:(NSString*)newText
                     line:(NSInteger)line{
  ATLabelWithFormCell* cell = (ATLabelWithFormCell*)controller.context;
  NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
  NSArray* models = [models_ objectAtIndex:indexPath.section];
  NSMutableDictionary* model = [models objectAtIndex:indexPath.row];

  if (textField.tag == kAddressLine) {
    NSMutableArray * addresses = [model objectForKey:@(kAddressLine)];
    switch (change) {
      case ATListViewTextFieldControlerDelegateUpdateChange:
        [addresses setObject:newText atIndexedSubscript:line];
        break;
      case ATListViewTextFieldControlerDelegateAddChange:
        [addresses insertObject:newText atIndex:line];
        [self updateTableViewCellHeights];
        break;
      case ATListViewTextFieldControlerDelegateDeleteChange:
        [addresses removeObjectAtIndex:line];
        [self updateTableViewCellHeights];
        break;
      default:break;
    }
  }else{
    [model setObject:newText forKey:@(textField.tag)];
  }
  self.editingCell = cell;
}

@end
