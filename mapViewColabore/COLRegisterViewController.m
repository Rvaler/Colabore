//
//  COLLoginViewController.m
//  Colaborê
//
//  Created by Rafael Valer on 3/6/15.
//  Copyright (c) 2015 com.Colaborê. All rights reserved.
//

#import "COLRegisterViewController.h"

@interface COLRegisterViewController ()

@property (strong, nonatomic) IBOutlet UITextField *nomeCompletoTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *usuarioTextField;
@property (strong, nonatomic) IBOutlet UITextField *senhaTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmarSenhaTextField;

@property (weak, nonatomic) IBOutlet UIButton *btRegister;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@property (nonatomic) COLUser *user;

-(void)registerErrorMessage:(NSString *)errorMessage;
@end

@implementation COLRegisterViewController{
    CGFloat _initialConstant;
}

static CGFloat keyboardHeightOffset = 15.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Registering for system notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _nomeCompletoTextField.delegate = self;
    _emailTextField.delegate = self;
    _usuarioTextField.delegate = self;
    _senhaTextField.delegate = self;
    _confirmarSenhaTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)cadastrarButtonAction:(id)sender {
//    
//    if ([_senhaTextField.text isEqual:_confirmarSenhaTextField.text]) {
//        COLUser *newUser = [[COLUser alloc] initWithCompleteName:_nomeCompletoTextField.text email:_emailTextField.text username:_usuarioTextField.text password:_senhaTextField.text];
//        NSLog(@"%@", newUser.username);
//        NSLog(@"%@", newUser.email);
//        NSLog(@"%@", newUser.completeName);
//        NSLog(@"%@", newUser.password);
//        
//    }
//
//}

//MARK: Keyboard Methods
- (IBAction)dismissKeyboard {
    
    // This method will resign all responders, dropping the keyboard.
    [self.view endEditing:YES];
    
}

- (void)keyboardWillShow:(NSNotification*)notification {

    // Getting the keyboard frame and animation duration.
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_initialConstant) {
        _initialConstant = _constraintBottom.constant;
    }
    
    // If screen can fit everything, leave the constant untouched.
    _constraintBottom.constant = MAX(keyboardFrame.size.height + keyboardHeightOffset, _initialConstant);
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        // This method will automatically animate all views to satisfy new constants.
        [self.view layoutIfNeeded];
    }];
    
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Putting everything back to place.
    _constraintBottom.constant = _initialConstant;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

//
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _nomeCompletoTextField) {
        [_emailTextField becomeFirstResponder];
    }else if (textField == _emailTextField){
        [_usuarioTextField becomeFirstResponder];
    }else if (textField == _usuarioTextField){
        [_senhaTextField becomeFirstResponder];
    }else if (textField == _senhaTextField){
        [_confirmarSenhaTextField becomeFirstResponder];
    }else if (textField == _confirmarSenhaTextField){
        [self dismissKeyboard];
    }
    
    
    return YES;
}

// when press cadastrar button, creates an user in database and go to Map View
- (IBAction)signUpButtonClicked:(UIButton *)sender {
    if([_nomeCompletoTextField.text isEqualToString:@""] ||
       [_emailTextField.text isEqualToString:@""] ||
       [_usuarioTextField.text isEqualToString:@""] ||
       [_senhaTextField.text isEqualToString:@""] ||
       [_confirmarSenhaTextField.text isEqualToString:@""])
    {
        [self registerErrorMessage:@"Preencha os campos corretamente"];
    }
    else if(![_senhaTextField.text isEqual:_confirmarSenhaTextField.text])
    {
        [self registerErrorMessage:@"As senhas não são compatíveis"];
    }
    else
    {
        __block COLUser *loggedUser = nil;
        PFUser *PFUnewUser = [PFUser user];
        PFUnewUser[@"completeName"] = _nomeCompletoTextField.text;
        PFUnewUser.email = _emailTextField.text;
        PFUnewUser.username = _usuarioTextField.text;
        PFUnewUser.password = _senhaTextField.text;
        
        [PFUnewUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                loggedUser = [[COLUser alloc] initWithCompleteName:_nomeCompletoTextField.text email:_emailTextField.text username:_usuarioTextField.text objectID:PFUnewUser.objectId];
                [[COLManager manager] setUser:loggedUser];
                
                [self performSegueWithIdentifier:@"segueRegisterToMap" sender:sender];
            }else{
                [self registerErrorMessage:@"Usuário já cadastrado."];
            }
        }];
    }
}
    
-(void)registerErrorMessage:(NSString *)errorMessage{
    [_btRegister setEnabled:NO];
    [UIView animateWithDuration:1.f animations:^{
        
        [_btRegister setBackgroundColor:[UIColor colorWithRed:225.f/255.f green:158.f/255.f blue:64.f/255.f alpha:1.f]];
        [_btRegister setTitle:errorMessage forState:UIControlStateNormal];
        
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.f delay:1.f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [_btRegister setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:49.f/255.f blue:55.f/255.f alpha:1.f]];
        } completion:^(BOOL finished){
            [_btRegister setEnabled:YES];
            [_btRegister setTitle:@"Cadastrar" forState:UIControlStateNormal];
        }];
    }];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if (![_senhaTextField.text isEqual:_confirmarSenhaTextField.text])
    return NO;
    
    return YES;
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

