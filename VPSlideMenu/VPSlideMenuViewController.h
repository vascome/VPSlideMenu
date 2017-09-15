//
//  VPSlideMenuViewController.h
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/16/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VPSlideMenuViewControllerDelegate <NSObject>

@end


IB_DESIGNABLE @interface VPSlideMenuViewController : UIViewController

@property (nonatomic) IBInspectable CGFloat leftViewWidth;
@property (nonatomic) IBInspectable CGFloat leftAreaWidth;
@property (nonatomic) IBInspectable BOOL leftPanEnabled;

@property (nonatomic) IBInspectable CGFloat rightViewWidth;
@property (nonatomic) IBInspectable CGFloat rightAreaWidth;
@property (nonatomic) IBInspectable BOOL rightPanEnabled;

@property (nonatomic) IBInspectable BOOL panGesturesEnabled;
@property (nonatomic) IBInspectable BOOL tapGesturesEnabled;


@property (nonatomic, copy) id<VPSlideMenuViewControllerDelegate> delegate;



@end
