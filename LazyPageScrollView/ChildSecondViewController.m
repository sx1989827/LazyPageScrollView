//
//  ChildSecondViewController.m
//  ChildViewController
//
//  Created by 孙昕 on 15/7/13.
//  Copyright (c) 2015年 孙昕. All rights reserved.
//

#import "ChildSecondViewController.h"

@interface ChildSecondViewController ()

@end

@implementation ChildSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"second didload %@ %ld %@",self.navigationController,self.navigationController.viewControllers.count,self.navigationController.topViewController);
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"second willappear");
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"second didappear");
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"second willdisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"second diddisappear");
}

-(void)dealloc
{
    NSLog(@"second dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
