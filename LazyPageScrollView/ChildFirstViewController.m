//
//  ChildFirstViewController.m
//  ChildViewController
//
//  Created by 孙昕 on 15/7/13.
//  Copyright (c) 2015年 孙昕. All rights reserved.
//

#import "ChildFirstViewController.h"

@interface ChildFirstViewController ()

@end

@implementation ChildFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"first didload %@ %ld %@ %@",self.navigationController,self.navigationController.viewControllers.count,self.navigationController.topViewController,[self topViewController]);

}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"first willappear");
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"first didappear  %@",_str);
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"first willdisappear");
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"first diddisappear");
}

-(void)dealloc
{
    NSLog(@"first dealloc");
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
- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

-(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


@end
