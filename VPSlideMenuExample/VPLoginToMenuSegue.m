//
//  VPLoginToMenuSegue.m
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/17/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "VPLoginToMenuSegue.h"
#import "VPSlideMenuViewController.h"
#import "LeftViewController.h"

@implementation VPLoginToMenuSegue

- (void)perform
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = self.destinationViewController;
}

@end
