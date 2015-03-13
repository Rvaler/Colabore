//
//  COLCategViewController.m
//  mapViewColabore
//
//  Created by Matheus Oliveira Rabelo on 09/03/15.
//  Copyright (c) 2015 Matheus Becker. All rights reserved.
//

#import "COLCategViewController.h"

@interface COLCategViewController ()

-(void)closeViewAnimated:(BOOL)animated;
-(void)sendInfoBack:(NSString *)info;

@property (nonatomic) NSMutableArray *dataSourceCategory;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategory;
@property (weak, nonatomic) IBOutlet UIView *viewCategoryPickerAndTb;

@property (nonatomic) NSString *previewText;

@end

@implementation COLCategViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_pickerCategory setDelegate:self];
    [_pickerCategory setDataSource:self];
    [_pickerCategory setShowsSelectionIndicator:YES];
    
    _dataSourceCategory = [[NSMutableArray alloc] init];
    for(NSInteger i = 0; i < 100; i++)
    {
        [_dataSourceCategory addObject:[NSString stringWithFormat:@"Teste %ld", i]];
    }
    _previewText = [[_pop txtCategory] text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendInfoBack:(NSString *)info
{
    [[_pop txtCategory] setText:info];
}
-(void)closeViewAnimated:(BOOL)animated
{
    if(animated)
    {
        [UIView animateWithDuration:.3f animations:^{
            
            [[self view] setAlpha:0.f];
            _viewCategoryPickerAndTb.frame = CGRectMake(0, self.view.frame.size.height, _viewCategoryPickerAndTb.frame.size.width, _viewCategoryPickerAndTb.frame.size.height);
        } completion:^(BOOL finished){
            if(finished)
            {
                [[self view] removeFromSuperview];
            }
        }];
    }
    else
    {
        [[self view] removeFromSuperview];
    }
}
- (void)showCategoryWithView:(UIView *)view animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self view] setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        
        [view addSubview:self.view];
        
        if(animated){
            [[self view] setAlpha:0.f];
            //[[self view] setTransform:CGAffineTransformMakeScale(1.0f, 0.f)];
            _viewCategoryPickerAndTb.frame = CGRectMake(0, self.view.frame.size.height, _viewCategoryPickerAndTb.frame.size.width, _viewCategoryPickerAndTb.frame.size.height);
            [UIView animateWithDuration:.3f animations:^{
                [[self view] setAlpha:1.f];
                _viewCategoryPickerAndTb.frame = CGRectMake(0, self.view.frame.size.height - _viewCategoryPickerAndTb.frame.size.height, _viewCategoryPickerAndTb.frame.size.width, _viewCategoryPickerAndTb.frame.size.height);
                //[[self view] setTransform:CGAffineTransformMakeScale(1.f, 1.f)];
            }];
        }
    });
}

- (IBAction)CancelAction:(UIBarButtonItem *)sender {
    [self sendInfoBack:_previewText];
    [self closeViewAnimated:YES];
}
- (IBAction)DoneAction:(id)sender {
    [self closeViewAnimated:YES];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataSourceCategory count];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [self sendInfoBack:[_dataSourceCategory objectAtIndex:row]];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataSourceCategory[row];
}
@end
