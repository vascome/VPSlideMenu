Pod::Spec.new do |s|
  s.name             = "VPSlideMenu"
  s.version          = "0.3.0"
  s.summary          = "Menu View Controller. It has left, right and main view controllers. Supported tap and pan gestures. Supported storyboards"
  s.homepage         = 'https://github.com/vascome/VPSlideMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vasily Popov' => 'vasily.popov.it@gmail.com' }
  s.source           = { :git => 'https://github.com/vascome/VPSlideMenu.git', :tag => s.version }
  s.ios.deployment_target = '9.0'
  s.source_files = 'VPSlideMenu/*.{h,m}'

end

