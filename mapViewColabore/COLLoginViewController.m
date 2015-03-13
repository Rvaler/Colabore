//
//  COLLoginViewController.m
//  Colaborê
//
//  Created by Diego dos Santos on 3/6/15.
//  Copyright (c) 2015 Diego dos Santos. All rights reserved.
//

#import "COLLoginViewController.h"

@interface COLLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *logoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetPasswordConstraint;

@end

@implementation COLLoginViewController{
    CGFloat _initialConstant;

}

static CGFloat keyboardHeightOffset = 5.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Registering for system notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //Logo Shadow
    _logoImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    _logoImageView.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    _logoImageView.layer.shadowOpacity = .4f;
    
    //Logo Label Shadow
    _logoLabel.shadowColor = [UIColor grayColor];
    _logoLabel.shadowOffset = CGSizeMake(1.f, 1.f);
    
    //Tags
    _userTextField.tag =1;
    _passwordTextField.tag=2;
    
    //Delegates
    _userTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboard {
    NSLog(@"Funfando");
    // This method will resign all responders, dropping the keyboard.
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        //ENTRAR
        [self performSegueWithIdentifier:@"segueLoginToMap" sender:textField];
    }
    return NO;
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_initialConstant) {
        _initialConstant = _forgetPasswordConstraint.constant;
    }
    
    // If screen can fit everything, leave the constant untouched.
    _forgetPasswordConstraint.constant = MAX(keyboardFrame.size.height + keyboardHeightOffset, _initialConstant);
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        // This method will automatically animate all views to satisfy new constants.
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Putting everything back to place.
    _forgetPasswordConstraint.constant = _initialConstant;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

- (IBAction)showRegister:(UIButton *)sender {
    [self performSegueWithIdentifier:@"segueLoginToRegister" sender:sender];
}
- (IBAction)showMap:(UIButton *)sender {
    if([[_userTextField text] isEqualToString:@""] || [[_passwordTextField text] isEqualToString:@""])
    {
        return;
    }
    [self performSegueWithIdentifier:@"segueLoginToMap" sender:sender];
}

-(IBAction)backFromRegisterToLogin:(UIStoryboardSegue *)segue
{
    
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
