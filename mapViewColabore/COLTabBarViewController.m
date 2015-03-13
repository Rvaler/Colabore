//
//  COLTabBarViewController.m
//  Colaborê
//
//  Created by Diego dos Santos on 3/7/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

#import "COLTabBarViewController.h"

@interface COLTabBarViewController ()

@end

@implementation COLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBar.tintColor = [UIColor colorWithRed:247.0f/255.0f green:74.0f/255.0f blue:71.0f/255.0f alpha:1.0f];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
