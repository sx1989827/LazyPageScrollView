# LazyPageScrollView
一个可以最大程度简化PageView与TabView切换的第三方框架

##演示效果

![](https://github.com/sx1989827/LazyPageScrollView/raw/master/Resource/1.gif)

![](https://github.com/sx1989827/LazyPageScrollView/raw/master/Resource/2.gif)

##简介
想必开发过app的开发者都有这样的痛点，如果要做一个可以切换tab的pageView估计不是一件容易的事情，比如订单模块，用户可以滑动在待付款，已完成和售后中三个view之间切换的话，会牵扯到不少的页面逻辑和交互，如果可以有一个一劳永逸的封装该有多好啊，每个页面的逻辑实现解耦，不同页面的切换和交互可以封装起来。于是，这个框架就是为了满足这样的需求而生的。

##它的优势
1.封装了大部分常见的功能，api简洁明了，且定制十分灵活，可以根据产品的不同定制出不同样式的pageview。

2.实现了页面切换和逻辑间的解耦，开发者无需关心pageview的切换，只需要关心每个view的刷新和显示。

3.多种创建方式，与xib无缝结合。

4.对于pageview为 [LazyTableView](https://github.com/sx1989827/LazyTableView) 的时候，进行了优化，防止多个tableview会有过多cell的情况，占用大量资源。（后续会完善更多优化）

##如何导入
将工程目录下的LazyPageScrollView文件夹导入你的工程内，这个文件夹只有两个文件：LazyPageScrollView.h,LazyPageScrollView.m。你只需要包含LazyPageScrollView.h文件即可。

##如何使用
在xib上拖入一个view，设置custom class为LazyPageScrollView，引入LazyPageScrollViewDelegate协议，连接控件变量为pageView。在m文件里加入如下代码：

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
      [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[lb]|" options:0 metrics:nil       views:NSDictionaryOfVariableBindings(lb)]];
      [topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lb(==1)]|" options:0 metrics:nil   views:NSDictionaryOfVariableBindings(lb)]];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          //_pageView.selectedIndex=4;
      });






