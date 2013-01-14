//
//  ATFormTableViewController.h
//  LabelWithForm
//
//  Created by Adrian Tofan on 09/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import <UIKit/UIKit.h>
// This is a base class suited for creating editable Contacts.app like forms
// based on ATLabelWithFormCell

typedef enum{
  ATSectionEditingStyleNotSet = 0,
  ATSectionEditingStyleNeverEmpty  = 1<<1, // needs to be shown by default when entering edit mode, cannot be completly deleted 0 

  ATSectionEditingStyleNotList            = 0<<8,
  ATSectionEditingStyleList               = 1<<8,    // is a list of elements that grows automaticaly
  ATSectionEditingStyleListWithAddButton  = 2<<8,    // grows with add button
  ATSectionEditingStyleStaticOnlyEdit       = 4<<8 , // has static elements, visible only when editing
  
} ATSectionEditingStyle;


@interface ATFormTableViewController : UITableViewController

#pragma mark - Table View Helpers
// triggers a table view update cycle.
// there is a bug in the tableView code which prevents height update in certain situations
// A potential solution is to keep a hidden section which is reloaded in a
// tableView beginEditing / endEditing block
-(void)updateTableViewCellHeights;

#pragma mark - Subclasses MUST call this methosds apropiately
// Call this method to update editing styles for cell
// WARNING: when switching to editing mode this method should be called for all
// visible cells
//
//        for (NSIndexPath *i in [self.tableView indexPathsForVisibleRows]) {
//          [self updateEditingStyleForCell:[self.tableView cellForRowAtIndexPath:i]
//                              atIndexPath:i];
//        }

-(void)updateEditingStyleForCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*)indexPath;

#pragma mark - model
#pragma mark - Subclasses MUST overwrite this methods
// Whatch out when using ! after model change previously computed
// model index path may change.
- (NSInteger) numberOfModelsInSection:(NSInteger)section;
- (void) insertEmptyModelAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL) isEmptyModelAtIndexPath:(NSIndexPath*)indexPath;
- (void) deleteModelAtIndexPath:(NSIndexPath*)indexPath;
- (void) deleteModelsAtIndexPaths:(NSArray*)indexPaths;
#pragma mark - model helpers
// how many empty model lines are in section
-(NSInteger)emptyModelLineCountInSection:(NSInteger)section;

#pragma mark - Edit management
// Caled from a tablbleView animation block when entering - ending edit mode

// Adds empty rows in lists or add buttons as needed
-(void)configureSectionForEditing:(NSInteger)section;
// Removes empty rows from lists and add buttons
-(void)configureSectionForEndingEditing:(NSInteger)section;
#pragma mark - Subclasses SHOULD propably overwrite this methods
// overide this two methods to configure static sections
// They are called from within a tableView.beginEditing/ tableView.endEditing
// inside of setEdit:animated:
-(void)configureStaticSectionForEditing:(NSInteger)section;
-(void)configureStaticSectionForEngingEditing:(NSInteger)section;

#pragma mark - Edit session 
// This methods MUST be invoked when the content of a cell is changing during a edit section
-(void)editingDidEndedAtIndexPath:(NSIndexPath*)indexPath;
// Call this during an edit section when editing a row when content changed (after model update)
-(void)editingInProgressAtIndexPath:(NSIndexPath*)indexPath;

#pragma mark - SectionEditingStyle
- (void) setEditingStyle:(ATSectionEditingStyle)style
                  forSection:(NSInteger)section;
- (ATSectionEditingStyle)editingStyleForSection:(NSInteger)section;

#pragma mark - Add buttons for dynamic sections
- (BOOL) isAddButonAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL) isAddButonVisibleInSection:(NSInteger)section;
- (void) setAddButonVisible:(BOOL)visible inSection:(NSInteger)section;
- (void) resetAllAddButtonsVisibility;
// Holds the current editing cell. When changes invokes  editingDidEndedAtIndexPath:
// respectively editingInProgressAtIndexPath:
@property (nonatomic)  UITableViewCell* editingCell;
@end
