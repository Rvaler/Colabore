//
//  COLConfigTableViewController.m
//  Colaborê
//
//  Created by Diego dos Santos on 3/7/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

#import "COLConfigTableViewController.h"

@interface COLConfigTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lbFullName;
@property (weak, nonatomic) IBOutlet UILabel *lbEmail;

@property (nonatomic) COLUser *user;

@end

@implementation COLConfigTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    COLTabBarViewController *tab = (COLTabBarViewController*)[self tabBarController];
//    _user = [tab user];
//    
//    
//    
//    [_lbFullName setText:[[tab user] completeName]];
//    [_lbEmail setText:[[tab user] email]];
    
    
    COLUser *user = [[COLManager manager] user];
    
    [_lbFullName setText:[user name]];
    [_lbEmail setText:[user email]];

    
    //Setting the title
    self.navigationController.navigationBar.topItem.title = @"Configurações";
    self.navigationController.navigationBar.backItem.title=@"Mapa";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"seguePerfilToEditPerfil"])
    {
        COLProfileTableViewController *editPerfil = segue.destinationViewController;
        [editPerfil setUser:_user];
    }
}
@end
