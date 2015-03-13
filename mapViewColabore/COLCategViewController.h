//
//  COLCategViewController.h
//  mapViewColabore
//
//  Created by Matheus Oliveira Rabelo on 09/03/15.
//  Copyright (c) 2015 Matheus Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COLPopUpViewController.h"

@interface COLCategViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) COLPopUpViewController *pop;

- (void)showCategoryWithView:(UIView *)view animated:(BOOL)animated;
@end
