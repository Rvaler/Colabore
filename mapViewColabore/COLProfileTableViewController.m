//
//  COLProfileTableViewController.m
//  Colaborê
//
//  Created by Diego dos Santos on 3/7/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

#import "COLProfileTableViewController.h"

@interface COLProfileTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@end

@implementation COLProfileTableViewController

-(IBAction)backFromPass:(UIStoryboardSegue *)segue{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_txtName setText:[_user name]];
    [_txtUser setText:[_user username]];
    [_txtEmail setText:[_user email]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
