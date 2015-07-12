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

3.对于pageview为[LazyTableView](https://github.com/sx1989827/LazyTableView)的时候，进行了优化，防止多个tableview会有过多cell的情况，占用大量资源。（后续会完善更多优化）

