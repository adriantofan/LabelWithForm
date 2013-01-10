//
//  ATTableViewController.m
//  LabelWithForm
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATTableViewController.h"
#import "ATListViewTextFieldControler.h"
#import "ATAddressCell.h"

@interface ATTableViewController (){
  NSMutableArray* models_;}
@end

@implementation ATTableViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  models_ = [NSMutableArray arrayWithArray:@[@3,@3]];
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  [self.tableView registerClass:[ATAddressCell  class] forCellReuseIdentifier:@"ATAddressCellId"];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
  [super setEditing:editing animated:animated];
  [[self tableView] beginUpdates];
  [[self tableView] endUpdates];
}

#pragma mark - TableView Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  ATAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ATAddressCellId"];
  cell.textFieldControllerDelegate = self;
  [cell setContent:@{@"s":@"s"}];   
  cell.label.text = @"Address";
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  CGRect frame = self.tableView.frame;
  CGFloat width = frame.size.width - (self.isEditing?(20.0+30.0):20.0);
  NSInteger count = [[models_ objectAtIndex:indexPath.row] integerValue];
  
  return [ATAddressCell cellHeigh:self.isEditing contentWidth:width  withText:@"some address \n with description" rowCount:count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
  return YES;
}

#pragma mark - TableView Delegate



#pragma mark - ATListViewTextFieldControlerDelegate

-(void)textFieldControler:(ATListViewTextFieldControler*)controller
            commitEditing:(ATListViewTextFieldControlerDelegateChange)change
                textField:(UITextField*)textField
                  oldText:(NSString*)oldText
                  newText:(NSString*)newText
                     line:(NSInteger)line{
  ATLabelWithFormCell* cell = (ATLabelWithFormCell*)controller.context;
  NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
  NSInteger count;
  
  switch (change) {
    case ATListViewTextFieldControlerDelegateUpdateChange:break;
    case ATListViewTextFieldControlerDelegateAddChange:
      count = [[models_ objectAtIndex:indexPath.row] integerValue];
      [models_ setObject:@(count + 1) atIndexedSubscript:indexPath.row];
      [self.tableView beginUpdates];
      [self.tableView endUpdates];
      break;
    case ATListViewTextFieldControlerDelegateDeleteChange:
      count = [[models_ objectAtIndex:indexPath.row] integerValue];
      [models_ setObject:@(count - 1) atIndexedSubscript:indexPath.row];
      [self.tableView beginUpdates];
      [self.tableView endUpdates];
      break;
    default:break;
  }
}


@end
