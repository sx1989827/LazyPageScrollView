//
//  LazyPageScrollView.m
//  LazyPageScrollView
//
//  Created by 孙昕 on 15/7/9.
//  Copyright (c) 2015年 孙昕. All rights reserved.
//

#import "LazyPageScrollView.h"
@implementation UIView(tag)
-(UIView*)_viewWithTag:(NSInteger)index
{
    for(UIView *view in self.subviews)
    {
        if(view.tag==index)
        {
            return view;
        }
    }
    return nil;
}
@end
@implementation LazyPageTabItem

@end
@interface LazyPageScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIView *viewTop;
    UIView *viewMain;
    UIScrollView *viewScrollTop;
    UIScrollView *viewScrollMain;
    UIFont *titleFont;
    UIFont *titleSelFont;
    UIColor *titleColor;
    UIColor *titleSelColor;
    UIView *viewContent;
    UIView *viewTopContent;
    NSInteger selIndex;
    UILabel *lbLine;
    BOOL bFitSize;
    CGFloat tabGap;
    CGFloat tabHeight;
    UIButton *selButton;
    NSMutableArray* arrData;
    NSLayoutConstraint *conLineCenterX;
    NSLayoutConstraint *conLineWidth;
    CGFloat LineBottomGap;
    CGFloat LineExtraWidth;
    CGFloat verticalDistance;
    BOOL bBreakline;
    CGFloat breakTopMargin;
    CGFloat breakBottomMargin;
    CGFloat breakWidth;
    UIColor *breakColor;
    BOOL bPageOptimize;
    UISwipeGestureRecognizer *rightRec;
    UISwipeGestureRecognizer *LeftRec;
    NSMutableArray *arrViewController;
    __weak UIViewController *selfVc;
    NSInteger actionIndex;
    BOOL bGenerate;
}
@end
@implementation LazyPageScrollView
-(void)initView
{
    actionIndex=-1;
    bGenerate=NO;
    rightRec=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onRightRec)];
    rightRec.delegate=self;
    rightRec.direction=UISwipeGestureRecognizerDirectionRight;
    LeftRec=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onLeftRec)];
    LeftRec.delegate=self;
    LeftRec.direction=UISwipeGestureRecognizerDirectionLeft;
    viewTop=[[UIView alloc] init];
    viewTop.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:viewTop];
    viewMain=[[UIView alloc] init];
    viewMain.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:viewMain];
    viewScrollTop=[[UIScrollView alloc] init];
    viewScrollTop.translatesAutoresizingMaskIntoConstraints=NO;
    viewScrollTop.showsVerticalScrollIndicator=NO;
    viewScrollTop.showsHorizontalScrollIndicator=NO;
    [viewTop addSubview:viewScrollTop];
    [viewTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewScrollTop]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewScrollTop)]];
    viewScrollMain=[[UIScrollView alloc] init];
    viewScrollMain.translatesAutoresizingMaskIntoConstraints=NO;
    viewScrollMain.showsHorizontalScrollIndicator=NO;
    viewScrollMain.showsVerticalScrollIndicator=NO;
    viewScrollMain.pagingEnabled=YES;
    [viewMain addSubview:viewScrollMain];
    [viewMain addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[viewScrollMain]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewScrollMain)]];
    [viewMain addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewScrollMain]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewScrollMain)]];
    viewContent=[[UIView alloc] init];
    viewContent.translatesAutoresizingMaskIntoConstraints=NO;
    [viewScrollMain addSubview:viewContent];
    viewScrollMain.delegate=self;
    viewScrollMain.tag=1;
    [viewScrollMain addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[viewContent]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewContent)]];
    [viewScrollMain addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewContent]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewContent)]];
    viewTopContent=[[UIView alloc] init];
    viewTopContent.translatesAutoresizingMaskIntoConstraints=NO;
    [viewScrollTop addSubview:viewTopContent];
    [viewScrollTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[viewTopContent]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewTopContent)]];
    [viewScrollTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewTopContent]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewTopContent)]];
    lbLine=[[UILabel alloc] init];
    lbLine.translatesAutoresizingMaskIntoConstraints=NO;
    [viewTopContent addSubview:lbLine];
    arrData=[[NSMutableArray alloc] initWithCapacity:30];
    arrViewController=[[NSMutableArray alloc] initWithCapacity:30];
}

-(void)dealloc
{
    for(UIViewController *vc in arrViewController)
    {
        if((NSNull*)vc!=[NSNull null])
        {
            [vc removeFromParentViewController];
        }
    }
    [arrViewController removeAllObjects];
    [arrData removeAllObjects];
    
}


-(instancetype)init
{
    if(self=[super init])
    {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self initView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        [self initView];
    }
    return self;
}

-(void)initTab:(BOOL)bFit Gap:(CGFloat)gap TabHeight:(CGFloat)height VerticalDistance:(CGFloat)distance BkColor:(UIColor *)color
{
    bFitSize=bFit;
    tabGap=gap;
    tabHeight=height;
    verticalDistance=distance;
    if(color)
    {
        viewTop.backgroundColor=color;
    }
}

-(void)enableTabBottomLine:(BOOL)bLine LineHeight:(CGFloat)height LineColor:(UIColor*)color LineBottomGap:(CGFloat)gap ExtraWidth:(CGFloat)width
{
    if(!bLine)
    {
        lbLine.hidden=YES;
        return;
    }
    else
    {
        lbLine.hidden=NO;
    }
    lbLine.backgroundColor=color;
    CGRect frame=lbLine.frame;
    frame.size.height=height;
    lbLine.frame=frame;
    LineBottomGap=gap;
    LineExtraWidth=width;
}


-(void)addTab:(NSString*)title View:(UIView*)view Info:(id)info
{
    LazyPageTabItem *item=[[LazyPageTabItem alloc] init];
    item.title=title;
    item.view=view;
    item.info=info;
    [arrData addObject:item];
}


-(void)generate:(void (^)(UIButton *firstTitleControl,UIView *viewTitleEffect))block
{
    bGenerate=YES;
    if(_delegate && [_delegate respondsToSelector:@selector(LazyPageScrollViewEdgeSwipe:Left:)])
    {
        viewScrollMain.bounces=NO;
    }
    [viewScrollMain addGestureRecognizer:rightRec];
    if(arrData.count==0)
    {
        [viewScrollMain addGestureRecognizer:LeftRec];
    }
    if(_leftTopView!=nil)
    {
        _leftTopView.translatesAutoresizingMaskIntoConstraints=NO;
        [viewTop addSubview:_leftTopView];
        [viewTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_leftTopView(==width)][viewScrollTop]" options:0 metrics:@{@"width":@(_leftTopView.bounds.size.width)} views:NSDictionaryOfVariableBindings(_leftTopView,viewScrollTop)]];
        [viewTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftTopView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftTopView)]];
    }
    else
    {
        [viewTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[viewScrollTop]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewScrollTop)]];
    }
    if(_rightTopView!=nil)
    {
        _rightTopView.translatesAutoresizingMaskIntoConstraints=NO;
        [viewTop addSubview:_rightTopView];
        [viewTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[viewScrollTop][_rightTopView(==width)]|" options:0 metrics:@{@"width":@(_rightTopView.bounds.size.width)} views:NSDictionaryOfVariableBindings(_rightTopView,viewScrollTop)]];
        [viewTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rightTopView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_rightTopView)]];
    }
    else
    {
        [viewTop addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[viewScrollTop]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewScrollTop)]];
    }
    [self addSubview:viewTop];
    [self addSubview:viewMain];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[viewTop]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewTop)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[viewMain]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewMain)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewTop(==tabHeight)]-verticalDistance-[viewMain]|" options:0 metrics:@{@"tabHeight":@(tabHeight),@"verticalDistance":@(verticalDistance)} views:NSDictionaryOfVariableBindings(viewTop,viewMain)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:viewMain attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewMain attribute:NSLayoutAttributeWidth multiplier:arrData.count constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewTopContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:viewTop attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    selfVc=[self topViewController];
    for(NSInteger i=0;i<arrData.count;i++)
    {
        LazyPageTabItem *item=arrData[i];
        UIView *view=nil;
        if([item.view isKindOfClass:[NSString class]])
        {
            if(i==0)
            {
                Class cls=NSClassFromString(item.view);
                UIViewController *vc=[[cls alloc] init];
                [arrViewController addObject:vc];
                if(item.info!=nil && [item.info isKindOfClass:[NSDictionary class]])
                {
                    for(NSString *key in item.info)
                    {
                        id obj=item.info[key];
                        [vc setValue:obj forKey:key];
                    }
                }
                [selfVc addChildViewController:vc];
                UIView *v=[[UIView alloc] init];
                vc.view.frame=v.bounds;
                vc.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                [v addSubview:vc.view];
                view=v;
            }
            else
            {
                view=[[UIView alloc] init];
                [arrViewController addObject:[NSNull null]];
            }
        }
        else if([item.view isKindOfClass:[UIView class]])
        {
            view=item.view;
            [arrViewController addObject:[NSNull null]];
        }
        view.translatesAutoresizingMaskIntoConstraints=NO;
        view.tag=100+i;
        [viewContent addSubview:view];
        [viewContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        if(i==0)
        {
            [viewContent addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:viewContent attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        }
        if(i==arrData.count-1)
        {
            [viewContent addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:viewContent attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }
        UIView *preView=[viewContent _viewWithTag:99+i];
        if(preView)
        {
            [viewContent addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:preView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            [viewContent addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:preView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        }
    }
    if(bFitSize)
    {
        CGFloat width=0;
        if(_leftTopView!=nil)
        {
            width-=_leftTopView.bounds.size.width;
        }
        if(_rightTopView!=nil)
        {
            width-=_rightTopView.bounds.size.width;
        }
        [self addConstraint:[NSLayoutConstraint constraintWithItem:viewTopContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewTop attribute:NSLayoutAttributeWidth multiplier:1 constant:width]];
        NSInteger tag=100;
        for(NSInteger i=0;i<arrData.count;i++)
        {
            UIButton *btn=[[UIButton alloc] init];
            btn.translatesAutoresizingMaskIntoConstraints=NO;
            [btn setTitle:((LazyPageTabItem*)arrData[i]).title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=tag++;
            if(titleColor)
            {
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            if(titleFont)
            {
                btn.titleLabel.font=titleFont;
            }
            [viewTopContent addSubview:btn];
            [viewTopContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)]];
            if(i==0)
            {
                [viewTopContent addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:viewTopContent attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                selButton=btn;
                if(titleSelColor) {
                    [selButton setTitleColor:titleSelColor forState:UIControlStateNormal];
                }
                else {
                    [selButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
            }
            if(i==arrData.count-1)
            {
                [viewTopContent addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:viewTopContent attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
            }
            UIView *preBtn=[viewTopContent _viewWithTag:tag-2];
            if(preBtn)
            {
                [viewTopContent addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:preBtn attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                [viewTopContent addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:preBtn attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                if(bBreakline)
                {
                    UILabel *lb=[[UILabel alloc] init];
                    lb.translatesAutoresizingMaskIntoConstraints=NO;
                    lb.backgroundColor=breakColor;
                    [viewTopContent addSubview:lb];
                    [viewTopContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[preBtn]-gap-[lb(==width)]" options:0 metrics:@{@"gap":@(-breakWidth/2),@"width":@(breakWidth)} views:NSDictionaryOfVariableBindings(preBtn,lb)]];
                    [viewTopContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[lb]-bottom-|" options:0 metrics:@{@"top":@(breakTopMargin),@"bottom":@(breakBottomMargin)} views:NSDictionaryOfVariableBindings(lb)]];
                }
            }
        }
    }
    else
    {
        CGFloat width=tabGap/2;
        NSInteger tag=100;
        for(LazyPageTabItem *item in arrData)
        {
            NSString *str=item.title;
            CGSize size=[str sizeWithAttributes:@{NSFontAttributeName:titleFont!=nil?titleFont:[[UIButton alloc] init].titleLabel.font}];
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(width, 0, size.width+10, viewTopContent.bounds.size.height)];
            btn.autoresizingMask=UIViewAutoresizingFlexibleHeight;
            [btn setTitle:str forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
            if(tag==100)
            {
                selButton=btn;
                if(titleSelColor) {
                    [selButton setTitleColor:titleSelColor forState:UIControlStateNormal];
                }
                else {
                    [selButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
            }
            btn.tag=tag++;
            if(titleColor)
            {
                [btn setTitleColor:titleColor forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            if(titleFont)
            {
                btn.titleLabel.font=titleFont;
            }
            [viewTopContent addSubview:btn];
            btn.autoresizingMask=UIViewAutoresizingFlexibleHeight;
            width+=size.width+10+tabGap;
            NSInteger i=tag-101;
            if(bBreakline &&  i!=arrData.count-1)
            {
                UILabel *lb=[[UILabel alloc] init];
                lb.translatesAutoresizingMaskIntoConstraints=NO;
                lb.backgroundColor=breakColor;
                [viewTopContent addSubview:lb];
                [viewTopContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[btn]-gap-[lb(==width)]" options:0 metrics:@{@"gap":@(tabGap/2-breakWidth/2),@"width":@(breakWidth)} views:NSDictionaryOfVariableBindings(btn,lb)]];
                [viewTopContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[lb]-bottom-|" options:0 metrics:@{@"top":@(breakTopMargin),@"bottom":@(breakBottomMargin)} views:NSDictionaryOfVariableBindings(lb)]];
            }
        }
        width-=tabGap/2;
        [viewTopContent addConstraint:[NSLayoutConstraint constraintWithItem:viewTopContent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil  attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:width]];
    }
    if(_viewTitleEffect)
    {
        [viewTopContent addSubview:_viewTitleEffect];
        [viewTopContent sendSubviewToBack:_viewTitleEffect];
        _viewTitleEffect.frame=[viewTopContent viewWithTag:100].frame;
    }
    if(lbLine.hidden==NO)
    {
        UIButton *btn=(UIButton*)[viewTopContent _viewWithTag:100];
        [viewTopContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lbLine(==height)]-gap-|" options:0 metrics:@{@"height":@(lbLine.bounds.size.height),@"gap":@(LineBottomGap)} views:NSDictionaryOfVariableBindings(lbLine)]];
        conLineCenterX=[NSLayoutConstraint constraintWithItem:lbLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        conLineWidth=[NSLayoutConstraint constraintWithItem:lbLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:btn.intrinsicContentSize.width+LineExtraWidth];
        [viewTopContent addConstraint:conLineWidth];
        [viewTopContent addConstraint:conLineCenterX];
    }
    [self layoutIfNeeded];
    if(block)
    {
        block([viewTopContent viewWithTag:100],_viewTitleEffect);
    }
}

-(LazyPageTabItem*)getTabItem:(NSInteger)index
{
    return arrData[index];
}


-(void)setTitleStyle:(UIFont*)font SelFont:(UIFont*)selFont Color:(UIColor*)color SelColor:(UIColor*)selColor
{
    titleFont=font;
    titleSelFont=selFont;
    titleColor=color;
    titleSelColor=selColor;
}

-(void)enableScroll:(BOOL)bScroll
{
    viewScrollMain.scrollEnabled=bScroll;
}

-(NSInteger)selectedIndex
{
    return selIndex;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(selectedIndex<0 || selectedIndex>=arrData.count)
    {
        return;
    }
    UIButton *btn=(UIButton*)[viewTopContent _viewWithTag:100+selectedIndex];
    [self onAction:btn];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset=scrollView.contentOffset;
    int indexNew=(offset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width;
    if(selIndex==indexNew)
    {
        return;
    }
    if(actionIndex!=-1)
    {
        if(actionIndex!=indexNew)
        {
            return;
        }
        else
        {
            actionIndex=-1;
        }
    }
    NSInteger preIndex=selIndex;
    selIndex=indexNew;
    UIButton *btn=(UIButton*)[viewTopContent _viewWithTag:100+selIndex];
    [self btnChange:btn];
    [self onPageChange:selIndex PreIndex:preIndex];
}



-(void)btnChange:(UIButton*)sender
{
    if(selButton==sender)
    {
        return;
    }
    if(titleColor)
    {
        [selButton setTitleColor:titleColor forState:UIControlStateNormal];
    }
    else
    {
        [selButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if(titleFont)
    {
        selButton.titleLabel.font=titleFont;
    }
    else
    {
        selButton.titleLabel.font=[UIFont systemFontOfSize:15];
    }
    selButton=sender;
    if(titleSelColor)
    {
        [selButton setTitleColor:titleSelColor forState:UIControlStateNormal];
    }
    else
    {
        [selButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    if(titleSelFont)
    {
        selButton.titleLabel.font=titleSelFont;
    }
}

- (void)onAction:(UIButton *)sender
{
    if(selButton==sender)
    {
        return;
    }
    if(titleColor)
    {
        [selButton setTitleColor:titleColor forState:UIControlStateNormal];
        
    }
    else
    {
        [selButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if(titleFont)
    {
        selButton.titleLabel.font=titleFont;
    }
    else
    {
        selButton.titleLabel.font=[UIFont systemFontOfSize:15];
    }
    selButton=sender;
    if(titleSelColor)
    {
        [selButton setTitleColor:titleSelColor forState:UIControlStateNormal];
    }
    else
    {
        [selButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    if(titleSelFont)
    {
        selButton.titleLabel.font=titleSelFont;
    }
    actionIndex=sender.tag-100;
    [viewScrollMain setContentOffset:CGPointMake(viewScrollMain.bounds.size.width*(sender.tag-100), 0) animated:NO];
}

-(void)onPageChange:(NSInteger)index PreIndex:(NSInteger)preIndex
{
    if(index==0)
    {
        [viewScrollMain addGestureRecognizer:rightRec];
    }
    else if (index==arrData.count-1)
    {
        [viewScrollMain addGestureRecognizer:LeftRec];
    }
    else
    {
        [viewScrollMain removeGestureRecognizer:rightRec];
        [viewScrollMain removeGestureRecognizer:LeftRec];
    }
    UIButton *btn=(UIButton*)[viewTopContent _viewWithTag:100+index ];
    [viewTopContent removeConstraint:conLineCenterX];
    conLineCenterX=[NSLayoutConstraint constraintWithItem:lbLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [viewTopContent addConstraint:conLineCenterX];
    conLineWidth.constant=btn.intrinsicContentSize.width+LineExtraWidth;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    if(index>0 && index<arrData.count-1)
    {
        LazyPageTabItem *item=arrData[index+1];
        if([item.view isKindOfClass:[UIView class]])
        {
            UIView *view=item.view;
            [self HandleView:view];
            item=arrData[index-1];
            view=item.view;
            [self HandleView:view];
        }
    }
    if(!bFitSize)
    {
        CGFloat x;
        if(index==0)
        {
            x=0;
        }
        else
        {
            x=tabGap/2;
            for(NSInteger i=100;i<btn.tag;i++)
            {
                UIButton *preBtn=(UIButton*)[viewTopContent _viewWithTag:i];
                x+=preBtn.bounds.size.width+tabGap;
            }
        }
        CGRect rect=CGRectMake(x-tabGap/2, 0, btn.bounds.size.width+tabGap, btn.bounds.size.height);
        [viewScrollTop scrollRectToVisible:rect animated:YES];
    }
    LazyPageTabItem *item=arrData[index];
    if([item.view isKindOfClass:[NSString class]])
    {
        if(arrViewController[index]==[NSNull null])
        {
            Class cls=NSClassFromString(item.view);
            UIViewController *vc=[[cls alloc] init];
            if(item.info!=nil && [item.info isKindOfClass:[NSDictionary class]])
            {
                for(NSString *key in item.info)
                {
                    id obj=item.info[key];
                    [vc setValue:obj forKey:key];
                }
            }
            [selfVc addChildViewController:vc];
            arrViewController[index]=vc;
            UIView *view=[viewContent _viewWithTag:100+index];
            [view addSubview:vc.view];
            vc.view.translatesAutoresizingMaskIntoConstraints=YES;
            vc.view.frame=view.bounds;
            vc.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        }
        else
        {
            UIViewController *vc=arrViewController[index];
            [vc beginAppearanceTransition:YES animated:NO];
            [vc endAppearanceTransition];
        }
    }
    item=arrData[preIndex];
    if([item.view isKindOfClass:[NSString class]])
    {
        UIViewController *vc=arrViewController[preIndex];
        [vc beginAppearanceTransition:NO animated:NO];
        [vc endAppearanceTransition];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(LazyPageScrollViewPageChange:Index:PreIndex:TitleEffectView:SelControl:)])
    {
        [_delegate LazyPageScrollViewPageChange:self Index:index PreIndex:preIndex TitleEffectView:_viewTitleEffect SelControl:btn];
    }
}

-(void)HandleView:(UIView*)view
{
    if([view isKindOfClass:NSClassFromString(@"LazyTableView")])
    {
        if(bPageOptimize)
        {
            [view performSelector:@selector(empty)];
        }
    }
}

-(UIView*)getTopContentView
{
    return viewTop;
}

-(void)enableBreakLine:(BOOL)bLine Width:(CGFloat)width TopMargin:(CGFloat)topMargin BottomMargin:(CGFloat)bottomMargin Color:(UIColor*)color
{
    bBreakline=bLine;
    breakWidth=width;
    breakTopMargin=topMargin;
    breakBottomMargin=bottomMargin;
    breakColor=color;
}

-(void)enableOptimize:(BOOL)bOptimize
{
    bPageOptimize=bOptimize;
}

-(void)onLeftRec
{
    if(_delegate && [_delegate respondsToSelector:@selector(LazyPageScrollViewEdgeSwipe:Left:)])
    {
        [_delegate LazyPageScrollViewEdgeSwipe:self Left:YES];
    }
}

-(void)onRightRec
{
    if(_delegate && [_delegate respondsToSelector:@selector(LazyPageScrollViewEdgeSwipe:Left:)])
    {
        [_delegate LazyPageScrollViewEdgeSwipe:self Left:NO];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (UIViewController*)topViewController {
    UIViewController *vc=nil;
    if([UIApplication sharedApplication].keyWindow.rootViewController!=nil)
    {
        vc=[UIApplication sharedApplication].keyWindow.rootViewController;
    }
    else if([[[UIApplication sharedApplication] delegate] window].rootViewController!=nil)
    {
        vc=[[[UIApplication sharedApplication] delegate] window].rootViewController;
    }
    return [self topViewControllerWithRootViewController:vc];
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

-(void)addTab:(NSString*)title ViewController:(NSString*)vc Param:(NSDictionary*)param
{
    LazyPageTabItem *item=[[LazyPageTabItem alloc] init];
    item.title=title;
    item.view=vc;
    item.info=param;
    [arrData addObject:item];
}

-(NSInteger)getTabCount
{
    return arrData.count;
}


@end








