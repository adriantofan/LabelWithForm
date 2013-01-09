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

@interface ATFullTableViewController (){
  NSMutableArray* models_;}

@end

@implementation ATFullTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  models_ = [NSMutableArray arrayWithObject:@3];
  [self.tableView registerClass:[ATAddressCell  class] forCellReuseIdentifier:@"ATAddressCellId"];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
  [super setEditing:editing animated:animated];
  if (editing) {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    self.navigationItem.leftBarButtonItem = cancelButton;
  }else{
  }
  [[self tableView] beginUpdates];
  [[self tableView] endUpdates];
}
#pragma mark - Button actions

-(IBAction)cancelPressed{
  // TODO: Cancel (somehow) edits
  self.navigationItem.leftBarButtonItem = nil;
  self.editing = NO;
  self.tableView.editing = NO;
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 1;
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

#pragma mark - ATListViewTextFieldControlerDelegate

-(void)textFieldControler:(ATListViewTextFieldControler*)controller
            commitEditing:(ATListViewTextFieldControlerDelegateChange)change
                textField:(UITextField*)textField
                  oldText:(NSString*)oldText
                  newText:(NSString*)newText{
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
