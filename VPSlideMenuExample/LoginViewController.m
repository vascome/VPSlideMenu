//
//  LoginViewController.m
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/17/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "VPSlideMenuViewController.h"
#import "LeftViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClicked:(id)sender {
    
    UIStoryboard *sBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *mainVC = [sBoard instantiateViewControllerWithIdentifier:@"MainVC"];
    LeftViewController *leftVC = (LeftViewController*)[sBoard instantiateViewControllerWithIdentifier:@"LeftVC"];
    UIViewController *rightVC = [sBoard instantiateViewControllerWithIdentifier:@"RightVC"];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    
    
    
    leftVC.mainViewController = nvc;
    
    VPSlideMenuViewController *slideMenuController = [[VPSlideMenuViewController alloc] initWithMainViewController:nvc leftViewController:leftVC rightViewController:rightVC];
    //slideMenuController.willMenuOverlapMainView = NO;
    [slideMenuController setAutomaticallyAdjustsScrollViewInsets:YES];
    

    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = slideMenuController;
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
