//
//  ATMainViewController.m
//  LabelWithForm
//
//  Created by Adrian Tofan on 09/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATMainViewController.h"
#import "ATTableViewController.h"
#import "ATFullTableViewController.h"
@interface ATMainViewController ()

@end

@implementation ATMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)showSimpleTouchUpInside:(id)sender {
  ATTableViewController *controller =
    [[ATTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
  [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)showFullTouchUpInside:(id)sender {
  ATFullTableViewController *controller =
    [[ATFullTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
  [self.navigationController pushViewController:controller animated:YES];
}
@end
