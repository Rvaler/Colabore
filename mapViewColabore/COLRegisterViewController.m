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

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@property (nonatomic) COLUser *user;

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
    if ([_senhaTextField.text isEqual:_confirmarSenhaTextField.text]) {
        __block COLUser *loggedUser = nil;
        PFUser *PFUnewUser = [PFUser user];
        PFUnewUser[@"completeName"] = _nomeCompletoTextField.text;
        PFUnewUser.email = _emailTextField.text;
        PFUnewUser.username = _usuarioTextField.text;
        PFUnewUser.password = _senhaTextField.text;
        
        [PFUnewUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                NSLog(@"registro efetuado com sucesso");
                
                loggedUser = [[COLUser alloc] initWithCompleteName:_nomeCompletoTextField.text email:_emailTextField.text username:_usuarioTextField.text objectID:PFUnewUser.objectId];
                [[COLManager manager] setUser:loggedUser];
                
                [self performSegueWithIdentifier:@"segueRegisterToMap" sender:sender];
            }else{
               
                NSLog(@"erro no registro");
            }
        }];
    }
}
    


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if (![_senhaTextField.text isEqual:_confirmarSenhaTextField.text])
    return NO;
    
    return YES;
}


 
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueRegisterToMap"]){
        _user = [[COLUser alloc] init];
        [_user setUsername: _usuarioTextField.text];
        [_user setName: _nomeCompletoTextField.text];
        [_user setEmail: _emailTextField.text];
        [_user setPassword: _senhaTextField.text];
        
       
        UINavigationController *navController = segue.destinationViewController;
        COLMapViewController *mapVc = (COLMapViewController*)[navController topViewController];

        [mapVc setUser: _user];
    }
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

