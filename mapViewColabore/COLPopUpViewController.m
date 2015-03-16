//
//  COLPopUpViewController.m
//  ColaboreDenunciePopUp
//
//  Created by Matheus Oliveira on 3/7/15.
//  Copyright (c) 2015 Matheus Oliveira. All rights reserved.
//

#import "COLPopUpViewController.h"
#import "COLCategViewController.h"
#import <Parse/Parse.h>

@interface COLPopUpViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtCat;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhotos;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrPhotoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrDescPos;

@property (nonatomic) COLCategViewController *categorias;

-(void)configureViewStyle;
-(void)dismissKeyboard:(UITapGestureRecognizer *)tapRecg;
-(void)EditPhoto:(UITapGestureRecognizer *)tapRecg;

@end

@implementation COLPopUpViewController
{
    CGFloat _initialConstPhotoHeight;
    CGFloat _initialConstDescPos;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EditPhoto:)];
    [tapPhoto setDelegate:self];
    [_imgPhotos setUserInteractionEnabled:YES];
    [_imgPhotos addGestureRecognizer:tapPhoto];
    
    UITapGestureRecognizer *tapDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapDismissKeyboard setDelegate:self];
    [_mainView setUserInteractionEnabled:YES];
    [_mainView addGestureRecognizer:tapDismissKeyboard];
    
    [_txtCategory setDelegate:self];
    [_txtDesc setDelegate:self];
    [_txtTitle setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == _txtDesc)
    {
        if([[_txtDesc.text lowercaseString] isEqualToString:@"descrição"])
        {
            _txtDesc.text = @"";
            _txtDesc.textColor = [UIColor darkGrayColor];
        }
    }
}
-(void)dismissKeyboard:(UITapGestureRecognizer *)tapRecg{
    [self.view endEditing:YES];
}


- (void)keyboardWillShow:(NSNotification*)notification {
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_initialConstDescPos) {
        _initialConstDescPos = _constrDescPos.constant;
    }
    if(!_initialConstPhotoHeight)
    {
        _initialConstPhotoHeight = _constrPhotoHeight.constant;
    }
    _constrPhotoHeight.constant = 0.f;
    _constrDescPos.constant = MAX(keyboardFrame.size.height - _initialConstDescPos - 50.f, _initialConstDescPos);
    
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [[self view] layoutIfNeeded];
    }];
    
}
- (void)keyboardWillHide:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Putting everything back to place.
    _constrPhotoHeight.constant = _initialConstPhotoHeight;
    _constrDescPos.constant = _initialConstDescPos;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [[self view] layoutIfNeeded];
    }];
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView == _txtDesc)
    {
        
        if([[_txtDesc.text lowercaseString] isEqualToString:@""])
        {
            _txtDesc.text = @"Descrição";
            _txtDesc.textColor = [UIColor lightGrayColor];
        }
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField == _txtCat)
    {
        [[self view] endEditing:YES];
        
        _categorias = [[COLCategViewController alloc] init];
        [_categorias setPop:self];
        [_categorias showCategoryWithView:self.view animated:YES];
        
        _categorias.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [self.view addSubview:_categorias.view];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _txtTitle)
    {
        [_txtCategory becomeFirstResponder];
    }
    else if(textField == _txtCategory)
    {
        [_txtDesc becomeFirstResponder];
    }
    
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    
    [_imgPhotos setContentMode:UIViewContentModeScaleAspectFit];
    [_imgPhotos setImage:img];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)EditPhoto:(UITapGestureRecognizer *)tapRecg {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setAllowsEditing:YES];
    
    UIAlertController *editPhoto = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Tirar foto" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [editPhoto addAction:takePhoto];
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIAlertAction *choosePhoto = [UIAlertAction actionWithTitle:@"Foto da galeria" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:picker animated:YES completion:nil];
            
        }];
        
        [editPhoto addAction:choosePhoto];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
    
    [editPhoto addAction:cancel];
    
    [self presentViewController:editPhoto animated:YES completion:nil];
    
}
- (IBAction)ClosePopUp:(UIButton *)sender {
    [UIView animateWithDuration:.5f
                     animations:^{
                         self.view.alpha = 0.f;
                         self.view.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             [self.view removeFromSuperview];
                         }
                     }];
}
- (IBAction)denunciar:(UIButton *)sender {
    
    if([[_txtTitle text] isEqualToString:@""] || [[_txtDesc text] isEqualToString:@""]  || [[[_txtDesc text] lowercaseString] isEqualToString:@"descrição"] || [[_txtCategory text] isEqualToString:@""])
    {
        /*UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Denúncia!" message:@"Preencha os campos corretamente..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok!" style:UIAlertActionStyleCancel handler:nil];
        
        [error addAction:ok];
        
        [self presentViewController:error animated:YES completion:nil];*/
        
        CGRect initialRect = _mainView.frame;
        
        [UIView animateWithDuration:.08f animations:^{
            _mainView.frame = CGRectMake(0, _mainView.frame.origin.y, _mainView.frame.size.width, _mainView.frame.size.height);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:.08f animations:^{
                _mainView.frame = CGRectMake(self.view.frame.size.width - _mainView.frame.size.width, _mainView.frame.origin.y, _mainView.frame.size.width, _mainView.frame.size.height);
            } completion:^(BOOL finished){
                [UIView animateWithDuration:.08f animations:^{
                    _mainView.frame = CGRectMake(0, _mainView.frame.origin.y, _mainView.frame.size.width, _mainView.frame.size.height);
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:.08f animations:^{
                        _mainView.frame = initialRect;
                    }];
                }];
            }];
        }];
        
        return;
    }
    
    [UIView animateWithDuration:.15f
                     animations:^{
                         //self.view.alpha = 0.f;
                         self.view.transform = CGAffineTransformMakeScale(.8f, .8f);
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             
                             [UIView animateWithDuration:.4f
                                              animations:^{
                                                  self.view.alpha = 0.f;
                                                  self.view.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                                              }
                                              completion:^(BOOL finished){
                                                  if(finished){
                                                      
                                                      // realiza a denuncia no BD
                                                      PFObject *newDenuncia = [PFObject objectWithClassName:@"Denuncia"];
                                                      newDenuncia[@"photo"] = 
                                                      
                                                      
                                                      //
                                                      
                                                      
                                                      UIAlertController *cadastrado = [UIAlertController alertControllerWithTitle:@"Denúncia!" message:@"Denúncia enviada..." preferredStyle:UIAlertControllerStyleAlert];
                                                      UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok!" style:UIAlertActionStyleCancel handler:^(UIAlertAction *alert){
                                                          
                                                          [self.view removeFromSuperview];
                                                      }];
                                                      
                                                      [cadastrado addAction:ok];
                                                      
                                                      [self presentViewController:cadastrado animated:YES completion:nil];
                                                  }
                                              }];
                             
                         }
                     }];
}
- (void)showPopUpOnView:(UIView *)superView animated:(BOOL)anim{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self view] setFrame:CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height)];
        [self configureViewStyle];
        
        [superView addSubview:self.view];
        
        if(anim){
            [[self view] setAlpha:0.f];
            [[self view] setTransform:CGAffineTransformMakeScale(1.3f, 1.3f)];
            [UIView animateWithDuration:.3f animations:^{
                [[self view] setAlpha:1.f];
                [[self view] setTransform:CGAffineTransformMakeScale(1.f, 1.f)];
            }];
        }
    });
}
- (void)configureViewStyle{
    [[_mainView layer] setMasksToBounds:YES];
    [[_mainView layer] setCornerRadius:5.f];
    
    /*
    [[_mainView layer] setShadowColor:[UIColor darkGrayColor].CGColor];
    [[_mainView layer] setShadowOpacity:.9f];
    [[_mainView layer] setShadowRadius:5.f];
    
    _mainView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_mainView.frame cornerRadius:5.f].CGPath;*/
}


@end
