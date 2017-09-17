# VPSlideMenu
Menu View Controller. It has left, right and main view controllers. Supported tap and pan gestures. Supported storyboards

VPSlideMenu
========================

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)


iOS Slide View

<img src="https://github.com/vascome/VPSlideMenu/blob/master/Screenshots/example.gif" width="314"/>

## Installation

#### CocoaPods
```
```
  
#### Carthage

if iOS8 or later, Carthage is supported

* Add `github "vascome/VPSlideMenu"` to your Cartfile.
* Run `carthage update`.

for more info, see [Carthage](https://github.com/carthage/carthage)

#### Manually
Add the `VPSlideMenu` files to your project. 

## Usage

### Setup

Add `#import <VPSLideMenu/VPSlideMenu.h>` in your file

#### Manual:

```objective-c

    UIStoryboard *sBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *mainVC = [sBoard instantiateViewControllerWithIdentifier:@"MainVC"];
    LeftViewController *leftVC = (LeftViewController*)[sBoard instantiateViewControllerWithIdentifier:@"LeftVC"];
    UIViewController *rightVC = [sBoard instantiateViewControllerWithIdentifier:@"RightVC"];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:mainVC];
    leftVC.mainViewController = nvc;
    
    VPSlideMenuViewController *slideMenuController = [[VPSlideMenuViewController alloc] initWithMainViewController:nvc leftViewController:leftVC rightViewController:rightVC];
    [slideMenuController setAutomaticallyAdjustsScrollViewInsets:YES];
    

    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController = slideMenuController;
```

#### Storyboard Support

1. put VPSlideMenuViewController in a storyboard.
2. add left, right and main vc (see project example)
 -  setup in code
```objective-c
VPSlideMenuViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    ((LeftViewController*)vc.leftVC).mainViewController = vc.mainVC;
    app.window.rootViewController = vc;
```

### You can access from UIViewController

```objective-c
[self slideMenuController]
```
### add navigationBarButton 
```objective-c
[self addLeftBarButtonWithImage:[UIImage imageNamed:@"left"]];
[self addrightBarButtonWithImage:[UIImage imageNamed:@"right"]];
```

## License
VPSlideMenu is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
