//
//  ATAppDelegate.m
//  LabelWithForm
//
//  Created by Adrian Tofan on 08/01/13.
//  Copyright (c) 2013 Adrian Tofan. All rights reserved.
//

#import "ATAppDelegate.h"
#import "ATMainViewController.h"

@implementation ATAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  ATMainViewController* controller = [[ATMainViewController alloc] initWithNibName:@"ATMainViewController"
                                                                            bundle:nil];
  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
  // Override point for customization after application launch.
  [self.window makeKeyAndVisible];
    return YES;
}
@end
