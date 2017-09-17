//
//  UIViewController+VPSlideMenu.m
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/17/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "UIViewController+VPSlideMenu.h"
#import "VPSlideMenuViewController.h"

@implementation UIViewController (VPSlideMenu)

-(VPSlideMenuViewController*) slideMenuController {
    
    UIViewController *vc = self;
    
    while (vc != nil) {
        if([vc isKindOfClass:[VPSlideMenuViewController class]]) {
            return (VPSlideMenuViewController*)vc;
        }
        vc = vc.parentViewController;
    }
    return nil;
}

-(void) toggleLeftMenu {
    [[self slideMenuController] toggleLeftMenu];
}


-(void) toggleRightMenu {
    [[self slideMenuController] toggleRightMenu];
}


-(void) openLeftMenu {
    [[self slideMenuController] openMenu:VPSlideMenuSideLeft animated:YES];
}


-(void) openRightMenu {
    [[self slideMenuController] openMenu:VPSlideMenuSideRight animated:YES];
}

-(void) closeLeftMenu {
    [[self slideMenuController] closeMenu:VPSlideMenuSideLeft animated:YES];
}


-(void) closeRightMenu {
    [[self slideMenuController] closeMenu:VPSlideMenuSideRight animated:YES];
}

@end
