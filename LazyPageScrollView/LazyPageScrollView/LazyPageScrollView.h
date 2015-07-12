//
//  LazyPageScrollView.h
//  LazyPageScrollView
//
//  Created by 孙昕 on 15/7/9.
//  Copyright (c) 2015年 孙昕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LazyPageScrollView ;
@interface LazyPageTabItem : NSObject
/**
 *  tab的title
 */
@property (strong,nonatomic) NSString* title;
/**
 *  tab所对应的自定义view
 */
@property (strong,nonatomic) UIView *view;
/**
 *  当前tab的附加用户信息
 */
@property (strong,nonatomic) id info;
@end
@protocol LazyPageScrollViewDelegate <NSObject>
/**
 *  当page改变的时候，会调用这个委托
 *
 *  @param pageScrollView 当前的pageScrollView
 *  @param index          当前的page的index索引
 *  @param preIndex       之前的page的index索引
 */
-(void)LazyPageScrollViewPageChange:(LazyPageScrollView*)pageScrollView Index:(NSInteger)index PreIndex:(NSInteger)preIndex;
/**
 *  当pageview滑动到边缘的时候，会调用这个委托
 *
 *  @param pageScrollView 当前的pageScrollView
 *  @param bLeft          如果bLeft为YES，则表示在scrollView的最右边手指向左滑动，否则表示在scrollView的最左边手指向右滑动
 */
-(void)LazyPageScrollViewEdgeSwipe:(LazyPageScrollView*)pageScrollView Left:(BOOL)bLeft;
@end
@interface LazyPageScrollView : UIView
/**
 *  获取和设置当前的page的index
 */
@property (assign,nonatomic) NSInteger selectedIndex;
/**
 *  当前LazyPageScrollView的delegate
 */
@property (weak,nonatomic) id<LazyPageScrollViewDelegate> delegate;
/**
 *  顶部view的左侧固定view
 */
@property (strong,nonatomic) UIView *leftTopView;
/**
 *  顶部view的右侧固定view
 */
@property (strong,nonatomic) UIView *rightTopView;
/**
 *  初始化tab
 *
 *  @param bFit     是否自动适应，如果自动适应的话，则tabView不会滚动，按照tab的个数自动分配tab的宽度，否则tabview可以滚动，且gap参数会起作用
 *  @param gap      tab之间的间隔
 *  @param height   tab的高度
 *  @param distance tabview和pageview的垂直间距
 *  @param color    tabview的背景颜色
 */
-(void)initTab:(BOOL)bFit Gap:(CGFloat)gap TabHeight:(CGFloat)height VerticalDistance:(CGFloat)distance BkColor:(UIColor*)color;
/**
 *  是否显示tab title下面的当前pageIndex的下划线标示，下划线的宽度默认和title的宽度一样大
 *
 *  @param bLine  是否显示下划线
 *  @param height 下划线的高度
 *  @param color  下划线的颜色
 *  @param gap    下划线距离topview底部的间距
 *  @param width  下划线的宽度=title的宽度+width
 */
-(void)enableTabBottomLine:(BOOL)bLine LineHeight:(CGFloat)height LineColor:(UIColor*)color LineBottomGap:(CGFloat)gap ExtraWidth:(CGFloat)width;
/**
 *  添加tab
 *
 *  @param title tab title
 *  @param view  pageView
 */
-(void)addTab:(NSString*)title View:(UIView*)view;
/**
 *  添加tab（以LazyPageTabItem的形式）
 *
 *  @param item
 */
-(void)addTab:(LazyPageTabItem*)item;
/**
 *  生成LazyPageScrollView，需要设置完相关属性后调用该函数生成
 */
-(void)generate;
/**
 *  获取指定index的item信息
 *
 *  @param index
 *
 *  @return 指定index的item
 */
-(LazyPageTabItem*)getTabItem:(NSInteger)index;
/**
 *  设置tab Title的样式
 *
 *  @param font     自提
 *  @param color    颜色
 *  @param selColor 选中后的颜色
 */
-(void)setTitleStyle:(UIFont*)font Color:(UIColor*)color SelColor:(UIColor*)selColor;
/**
 *  用户手指是否可以在pageView上滑动切换page
 *
 *  @param bScroll 为YES表示手势可用
 */
-(void)enableScroll:(BOOL)bScroll;
/**
 *  获取LazyPageScrollView的顶部View
 *
 *  @return 顶部View
 */
-(UIView*)getTopContentView;
/**
 *  设置tab之间分割线的样式
 *
 *  @param bLine        分割线是否显示
 *  @param width        分割线的宽度
 *  @param topMargin    分割线距离顶部的距离
 *  @param bottomMargin 分割线距离底部的距离
 *  @param color        分割线的颜色
 */
-(void)enableBreakLine:(BOOL)bLine Width:(CGFloat)width TopMargin:(CGFloat)topMargin BottomMargin:(CGFloat)bottomMargin Color:(UIColor*)color;
/**
 *  是否开启Page切换的优化，目前只支持（LazyTableView）
 *
 *  @param bOptimize 为YES，表示开启
 */
-(void)enableOptimize:(BOOL)bOptimize;
@end




