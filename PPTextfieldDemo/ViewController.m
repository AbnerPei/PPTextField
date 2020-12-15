//
//  ViewController.m
//  PPTextfieldDemo
//
//  Created by Abner on 16/10/10.
//  Copyright © 2016年 PPAbner. All rights reserved.
//

#import "ViewController.h"
#import "PPTextFieldExampleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:176/255.0 green:23/255.0 blue:31/255.0 alpha:1.0];
    self.title = @"PPTextField";
    
    [self pushToExampleVC:NO];
    
}

- (void)pushToExampleVC:(BOOL)animated
{
    PPTextFieldExampleViewController *vc = [[PPTextFieldExampleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self pushToExampleVC:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
