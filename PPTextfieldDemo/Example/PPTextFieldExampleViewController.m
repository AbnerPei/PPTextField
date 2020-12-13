//
//  PPTextFieldExampleViewController.m
//  PPTextfieldDemo
//
//  Created by PPAbner on 2020/12/12.
//  Copyright © 2020 PPAbner. All rights reserved.
//

#import "PPTextFieldExampleViewController.h"
#import <PPTextField/PPTextField.h>
@interface PPTextFieldExampleViewController ()

@end

@implementation PPTextFieldExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:176/255.0 green:23/255.0 blue:31/255.0 alpha:1.0];
    self.title = @"PPTextField";
    
    [self test_PPTextField];
}


- (void)test_PPTextField
{
    UILabel *lb_onlyNumber = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 200, 20)];
    [self.view addSubview:lb_onlyNumber];
    lb_onlyNumber.text = @"01-只能输入数字";
    
    PPTextField *tf_onlyNumber = [[PPTextField alloc]initWithFrame:CGRectMake(20, 110, 300, 30)];
    [self.view addSubview:tf_onlyNumber];
    tf_onlyNumber.isOnlyNumber = YES;
    tf_onlyNumber.placeholder = @"设置maxTextLength即可限制最多数字个数";
    tf_onlyNumber.borderStyle = UITextBorderStyleRoundedRect;
    
    //=========
    
    UILabel *lb_isPrice = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 200, 20)];
    [self.view addSubview:lb_isPrice];
    lb_isPrice.text = @"02-价格";
    
    PPTextField *tf_isPrice = [[PPTextField alloc]initWithFrame:CGRectMake(20, 180, 200, 30)];
    [self.view addSubview:tf_isPrice];
    tf_isPrice.isPrice = YES;
    tf_isPrice.placeholder = @"tf_isPrice";
    tf_isPrice.borderStyle = UITextBorderStyleRoundedRect;
    
    
    //==========区分中英
    
    UILabel *lb_maxCharactersLength = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 300, 20)];
    [self.view addSubview:lb_maxCharactersLength];
    lb_maxCharactersLength.text = @"03-区分中英文，最多8个";
    PPTextField *tf_maxCharactersLength = [[PPTextField alloc]initWithFrame:CGRectMake(20, 250, 300, 30)];
    [self.view addSubview:tf_maxCharactersLength];
    tf_maxCharactersLength.maxTextLength = 8;
    tf_maxCharactersLength.maxLengthStyle = PPTextFieldMaxLengthStyleCN2EN1;
    tf_maxCharactersLength.didChangedTextBlockTiming = PPTextFieldDidChangedTextBlockTimingIfChanged;
    tf_maxCharactersLength.placeholder = @"设置为maxTextLength，则不区分";
    tf_maxCharactersLength.borderStyle = UITextBorderStyleRoundedRect;
    
    
    tf_maxCharactersLength.didChangedTextBlock = ^(PPTextField * _Nonnull tf) {
        NSLog(@"输入框内容变化了 %@",tf.text);
    };
    
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
