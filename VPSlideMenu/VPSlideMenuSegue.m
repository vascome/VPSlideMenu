//
//  VPSlideMenuSegue.m
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/17/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "VPSlideMenuSegue.h"
#import "VPSlideMenuViewController.h"

@interface VPSlideMenuViewController(VPSlideMenuSegue)

-(void)setMainVC:(UIViewController *)vc;
-(void)setLeftVC:(UIViewController *)vc;
-(void)setRightVC:(UIViewController *)vc;

@end

@implementation VPSlideMenuSegue

- (void)perform
{
    NSString *lowercaseIdentifier = self.identifier.lowercaseString;
    if ([lowercaseIdentifier isEqualToString:VPSideMenuSegueMainIdentifier])
    {
        [(VPSlideMenuViewController *)self.sourceViewController setMainVC:self.destinationViewController];
    }
    else if ([lowercaseIdentifier isEqualToString:VPSideMenuSegueLeftIdentifier])
    {
        [(VPSlideMenuViewController *)self.sourceViewController setLeftVC:self.destinationViewController];
    }
    else if ([lowercaseIdentifier isEqualToString:VPSideMenuSegueRightIdentifier])
    {
        [(VPSlideMenuViewController *)self.sourceViewController setRightVC:self.destinationViewController];
    }
}

@end
