//
//  MainViewController.m
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/17/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+VPSlideMenu.h"
#import "VPSlideMenuViewController.h"

@interface MainViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataSource;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    dataSource = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M"];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarItem];
}

-(void)dealloc {
    
}


-(void) addLeftBarButtonWithImage:(UIImage*)buttonImage {
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftMenu)];
    self.navigationItem.leftBarButtonItem = button;
}

-(void) addRightBarButtonWithImage:(UIImage*)buttonImage {
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleRightMenu)];
    self.navigationItem.rightBarButtonItem = button;
}


-(void) setNavigationBarItem {
    
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"left"]];
    [self addRightBarButtonWithImage:[UIImage imageNamed:@"right"]];
    VPSlideMenuViewController *vc = [self slideMenuController];
    
    if(vc) {
        
        [vc removeLeftGestures];
        [vc removeRightGestures];
        [vc addLeftGestures];
        [vc addRightGestures];
        
    }
    
   
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

@end
