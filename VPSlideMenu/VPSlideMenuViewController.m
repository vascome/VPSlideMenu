//
//  VPSlideMenuViewController.m
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/16/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "VPSlideMenuViewController.h"

typedef enum : NSUInteger {
    VPSlideMenuActionOpen,
    VPSlideMenuActionClose,
} VPSlideMenuAction;

struct PanGuestureDetail {
    VPSlideMenuAction action;
};

@interface VPSlideMenuViewController ()

@end

@implementation VPSlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
