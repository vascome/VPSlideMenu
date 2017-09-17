//
//  VPSlideMenuViewController.h
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/16/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VPSlideMenuSideLeft,
    VPSlideMenuSideRight,
} VPSlideMenuSide;

@protocol VPSlideMenuViewControllerDelegate <NSObject>

-(void)menuWillOpen:(VPSlideMenuSide)menu;
-(void)menuDidOpened:(VPSlideMenuSide)menu;
-(void)menuWillClose:(VPSlideMenuSide)menu;
-(void)menuDidClosed:(VPSlideMenuSide)menu;


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

@property (nonatomic) IBInspectable CGFloat animationDuration;
@property (nonatomic) IBInspectable CGFloat minPanWidth;


@property (nonatomic, copy) _Nullable id<VPSlideMenuViewControllerDelegate> delegate;



-(instancetype _Nullable )initWithMainViewController:(nonnull UIViewController*) mainViewController
                                 leftViewController:(nullable UIViewController*) leftViewController
                                rightViewController:(nullable UIViewController*) rightViewController;

-(void)setMainViewController:(nonnull UIViewController *)vc collapse:(BOOL) collapse;
-(void)setLeftViewController:(nonnull UIViewController *)vc collapse:(BOOL) collapse;
-(void)setRightViewController:(nonnull UIViewController *)vc collapse:(BOOL) collapse;

-(void) toggleLeftMenu;
-(void) toggleRightMenu;

-(void)openMenu:(VPSlideMenuSide)type animated:(BOOL)animated;
-(void)closeMenu:(VPSlideMenuSide)type animated:(BOOL)animated;

-(void)removeLeftGestures;
-(void)removeRightGestures;
-(void)addRightGestures;
-(void)addLeftGestures;

@end
