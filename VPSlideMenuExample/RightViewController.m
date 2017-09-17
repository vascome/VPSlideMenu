//
//  RightViewController.m
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/17/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "RightViewController.h"
#import <VPSLideMenu/VPSlideMenu.h>

@interface RightViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataSource;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = @[@"Menu1", @"Menu2", @"Menu3", @"Menu4", @"Menu5"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = dataSource[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VPSlideMenuViewController *vc = [self slideMenuController];
    
    if(vc) {
        
        UIViewController *newVC = [UIViewController new];
        newVC.view.backgroundColor = [UIColor colorWithRed:(indexPath.row*50+1)/255.0 green:1.0 blue:(indexPath.row*50+1)/255.0 alpha:1.0];
        [vc setMainViewController:[[UINavigationController alloc] initWithRootViewController: newVC] collapse:YES];
    }
}

@end
