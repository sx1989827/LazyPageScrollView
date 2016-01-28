Pod::Spec.new do |s|
  s.name         = "LazyPageScrollView"
  s.version      = "1.1"
  s.summary      = "A maximum of third parties to simplify the PageView and TabView switching"

  s.description  = <<-DESC
                   1 packaging most of the common features, API concise, and custom is very flexible, according to the different products can be customized according to different styles of pageview.
2 to realize the page switching and the decoupling between the logic, the developer does not need to care about the pageview switch, just care for each view refresh and display.
More than 3 create a way, and Xib seamless.
4 for pageview LazyTableView, for the optimization, to prevent multiple tableview will have too much cell, take a lot of resources. (follow-up will improve more optimization)
5 source only a h and M files, and no use of any other third party libraries.
6 can be combined with ViewController, the viewController into the pageView page, similar to the form of UITabBar.
                   DESC

  s.homepage     = "https://github.com/sx1989827/LazyPageScrollView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "sx1989827" => "" }
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/sx1989827/LazyPageScrollView.git", :tag => '1.1'}
  s.source_files = "LazyPageScrollView/LazyPageScrollView/*.{h,m}"
  s.requires_arc = true
end