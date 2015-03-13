//
//  COLPopUpViewController.h
//  ColaboreDenunciePopUp
//
//  Created by Matheus Oliveira on 3/7/15.
//  Copyright (c) 2015 Matheus Oliveira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface COLPopUpViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCategory;

-(void)showPopUpOnView:(UIView *)superView animated:(BOOL)anim;

@end
