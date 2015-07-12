//
//  ViewController.m
//  LazyPageScrollView
//
//  Created by 孙昕 on 15/7/9.
//  Copyright (c) 2015年 孙昕. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<LazyPageScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageView.delegate=self;
    [_pageView initTab:YES Gap:50 TabHeight:40 VerticalDistance:10 BkColor:[UIColor lightGrayColor]];
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor orangeColor];
    [_pageView addTab:@"as1" View:view];
    view=[[UIView alloc] init];
    view.backgroundColor=[UIColor greenColor];
    [_pageView addTab:@"a34" View:view];
    view=[[UIView alloc] init];
    view.backgroundColor=[UIColor lightGrayColor];
    [_pageView addTab:@"d2f4" View:view];
    view=[[UIView alloc] init];
    view.backgroundColor=[UIColor purpleColor];
    [_pageView addTab:@"reg" View:view];
    view=[[UIView alloc] init];
    view.backgroundColor=[UIColor grayColor];
    [_pageView addTab:@"a3435" View:view];
    [_pageView enableTabBottomLine:YES LineHeight:3 LineColor:[UIColor redColor] LineBottomGap:5 ExtraWidth:10];
    [_pageView setTitleStyle:[UIFont systemFontOfSize:15] Color:[UIColor blackColor] SelColor:[UIColor redColor]];
    [_pageView enableBreakLine:YES Width:1 TopMargin:0 BottomMargin:0 Color:[UIColor groupTableViewBackgroundColor]];
    UIView* leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    leftView.backgroundColor=[UIColor blackColor];
    _pageView.leftTopView=leftView;
    UIView* rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    rightView.backgroundColor=[UIColor purpleColor];
    _pageView.rightTopView=rightView;
    [_pageView generate];
    UIView *topView=[_pageView getTopContentView];
    UILabel *lb=[[UILabel alloc] init];
    lb.translatesAutoresizingMaskIntoConstraints=NO;
    lb.backgroundColor=[UIColor darkTextColor];
    [topView addSubview:lb];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[lb]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lb(==1)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lb)]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //_pageView.selectedIndex=4;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LazyPageScrollViewPageChange:(LazyPageScrollView *)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    NSLog(@"%ld %ld",preIndex,index);
}


-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView *)pageScrollView Left:(BOOL)bLeft
{
    if(bLeft)
    {
        NSLog(@"left");
    }
    else
    {
        NSLog(@"right");
    }
}
@end








