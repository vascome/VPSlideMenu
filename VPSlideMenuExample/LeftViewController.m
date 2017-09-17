//
//  ViewController.m
//  VPSlideMenuExample
//
//  Created by Vasily Popov on 9/16/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+VPSlideMenu.h"
#import "VPSlideMenuViewController.h"
#import "AppDelegate.h"

@interface LeftViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataSource;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = @[@"Main", @"First", @"Second", @"logout"];
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
    
        switch(indexPath.row)
        {
        case 0:
                [vc setMainViewController:self.mainViewController collapse:YES];
                break;
        case 1:
        case 2:
                [vc setMainViewController:[[UINavigationController alloc] initWithRootViewController: [UIViewController new]] collapse:YES];
                break;
        case 3:
            {
                AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                app.window.rootViewController = [[UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
            }
                break;
        }
    }
}

@end

