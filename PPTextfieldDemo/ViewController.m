//
//  ViewController.m
//  PPTextfieldDemo
//
//  Created by Abner on 16/10/10.
//  Copyright © 2016年 PPAbner. All rights reserved.
//

#import "ViewController.h"
#import "PPTextfield.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:176 green:23 blue:31 alpha:1.0];
    
    UILabel *lb_onlyNumber = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 200, 20)];
    [self.view addSubview:lb_onlyNumber];
    lb_onlyNumber.text = @"01-只能输入数字";
    
    PPTextfield *tf_onlyNumber = [[PPTextfield alloc]initWithFrame:CGRectMake(20, 110, 300, 30)];
    [self.view addSubview:tf_onlyNumber];
    tf_onlyNumber.isOnlyNumber = YES;
    tf_onlyNumber.placeholder = @"设置maxNumberCount即可限制最多数字个数";
    tf_onlyNumber.borderStyle = UITextBorderStyleRoundedRect;
    
    //=========
    
    UILabel *lb_isPrice = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 200, 20)];
    [self.view addSubview:lb_isPrice];
    lb_isPrice.text = @"02-价格";
    
    PPTextfield *tf_isPrice = [[PPTextfield alloc]initWithFrame:CGRectMake(20, 180, 200, 30)];
    [self.view addSubview:tf_isPrice];
    tf_isPrice.isPrice = YES;
    tf_isPrice.placeholder = @"tf_isPrice";
    tf_isPrice.borderStyle = UITextBorderStyleRoundedRect;
    
    
    //==========区分中英
    
    UILabel *lb_maxCharactersLength = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 300, 20)];
    [self.view addSubview:lb_maxCharactersLength];
    lb_maxCharactersLength.text = @"03-区分中英文，最多8个";
    
    PPTextfield *tf_maxCharactersLength = [[PPTextfield alloc]initWithFrame:CGRectMake(20, 250, 300, 30)];
    [self.view addSubview:tf_maxCharactersLength];
    tf_maxCharactersLength.maxCharactersLength = 8;
    tf_maxCharactersLength.placeholder = @"设置为maxTextLength，则不区分";
    tf_maxCharactersLength.borderStyle = UITextBorderStyleRoundedRect;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
