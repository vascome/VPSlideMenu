//
//  VPSlideMenuViewController.m
//  VPSlideMenu
//
//  Created by Vasily Popov on 9/16/17.
//  Copyright © 2017 Vasily Popov. All rights reserved.
//

#import "VPSlideMenuViewController.h"

typedef enum : NSUInteger {
    VPSlideMenuActionOpen,
    VPSlideMenuActionClose,
} VPSlideMenuAction;

struct PanGuestureDetail {
    VPSlideMenuAction action;
    CGFloat velocity;
};


struct PanState {
    CGRect panFrameStarted;
    CGPoint panPointStarted;
    BOOL wasOpenAtStart;
    BOOL wasHiddenAtStart;
    UIGestureRecognizerState lastState;
};


@interface VPSlideMenuViewController ()<UIGestureRecognizerDelegate>
{
    UIView *containerOpacityView;
    
    
    UIPanGestureRecognizer *leftPanRecognazer;
    UIPanGestureRecognizer *rightPanRecognazer;
    
    UITapGestureRecognizer *leftTapRecognazer;
    UITapGestureRecognizer *rightTapRecognazer;
    
    struct PanState leftPan;
    struct PanState rightPan;
    
}

@property (nonatomic, strong) UIView *leftContainerView;
@property (nonatomic, strong) UIView *rightContainerView;
@property (nonatomic, strong) UIView *containerView;


@end

@implementation VPSlideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.storyboard)
    {
        @try
        {
            [self performSegueWithIdentifier:VPSideMenuSegueMainIdentifier sender:nil];
        }
        @catch (NSException *exception) {}
        
        @try
        {
            [self performSegueWithIdentifier:VPSideMenuSegueLeftIdentifier sender:nil];
        }
        @catch (NSException *exception) {}
        
        @try
        {
            [self performSegueWithIdentifier:VPSideMenuSegueRightIdentifier sender:nil];
        }
        @catch (NSException *exception) {}
    }
    [self initView];
    // Do any additional setup after loading the view.
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    _containerView.transform = CGAffineTransformScale(_containerView.transform, 1.0, 1.0);
    _rightContainerView.hidden = YES;
    _leftContainerView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(strongSelf) {
            [strongSelf closeMenu:VPSlideMenuSideLeft animated:NO];
            [strongSelf closeMenu:VPSlideMenuSideRight animated:NO];
            strongSelf.rightContainerView.hidden = NO;
            strongSelf.leftContainerView.hidden = NO;
            [strongSelf removeLeftGestures];
            [strongSelf addLeftGestures];
            [strongSelf removeRightGestures];
            [strongSelf addRightGestures];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if(_mainVC != nil) {
        return [_mainVC supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate {
    if(_mainVC != nil) {
        return [_mainVC shouldAutorotate];
    }
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    if(_mainVC != nil) {
        return [_mainVC preferredStatusBarStyle];
    }
    return UIStatusBarStyleDefault;
}

-(void)viewWillLayoutSubviews {
    
    [self setViewController:_mainVC toContainer:_containerView];
    [self setViewController:_leftVC toContainer:_leftContainerView];
    [self setViewController:_rightVC toContainer:_rightContainerView];
}

-(void)dealloc {
    [self openStatusBar];
    NSLog(@"VPSlideMenuViewController dealloc");
}

#pragma mark - init

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupDefaultValues];
}

-(instancetype)initWithMainViewController:(UIViewController*) mainViewController
                       leftViewController:(UIViewController*) leftViewController
                      rightViewController:(UIViewController*) rightViewController
{
    self = [super init];
    if(self) {
        self.mainVC = mainViewController;
        self.leftVC = leftViewController;
        self.rightVC = rightViewController;
        [self setupDefaultValues];
    }
    return self;
}

-(void)setupDefaultValues
{
     _leftViewWidth = 160.0;
     _leftAreaWidth = 10.0;
     _leftPanEnabled = YES;
    
     _rightViewWidth = 160.0;
     _rightAreaWidth = 10.0;
     _rightPanEnabled = YES;
    
     _panGesturesEnabled = YES;
     _tapGesturesEnabled = YES;
    
    _willMenuOverlapMainView = YES;
    _animationDuration = 0.5;
    _minPanWidth = 100;
    _hideStatusBar = YES;
}

- (void) initView {
    _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:_containerView atIndex:0];
    
    if(self.leftVC != nil) {
        
        CGRect frame = self.view.bounds;
        frame.size.width = _leftViewWidth;
        frame.origin.x = [self leftMenuOriginForClosedState];
        
        _leftContainerView = [[UIView alloc] initWithFrame:frame];
        _leftContainerView.backgroundColor = [UIColor clearColor];
        _leftContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_leftContainerView];
    }
    
    if(self.rightVC != nil) {
        
        CGRect frame = self.view.bounds;
        frame.size.width = _rightViewWidth;
        frame.origin.x = [self rightMenuOriginForClosedState];
        
        _rightContainerView = [[UIView alloc] initWithFrame:frame];
        _rightContainerView.backgroundColor = [UIColor clearColor];
        _rightContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_rightContainerView];
    }
    
    leftPan.panFrameStarted = CGRectZero;
    leftPan.panPointStarted = CGPointZero;
    leftPan.wasHiddenAtStart = NO;
    leftPan.wasOpenAtStart = NO;
    leftPan.lastState = UIGestureRecognizerStateEnded;
    
    
    rightPan.panFrameStarted = CGRectZero;
    rightPan.panPointStarted = CGPointZero;
    rightPan.wasHiddenAtStart = NO;
    rightPan.wasOpenAtStart = NO;
    rightPan.lastState = UIGestureRecognizerStateEnded;
    
}

- (CGFloat) leftMenuOriginForClosedState {
    return  -self.leftViewWidth;
}

- (CGFloat) rightMenuOriginForClosedState {
    return  self.view.bounds.size.width;
}

#pragma mark - public API

-(void)setMainViewController:(UIViewController *)vc collapse:(BOOL) collapse {
    
    if(vc != _mainVC) //reference comparison
    {
        [self removeViewController:_mainVC];
        _mainVC = vc;
        [self setViewController:vc toContainer:_containerView];
    }

    if (collapse) {
        [self closeMenu:VPSlideMenuSideLeft animated:YES];
        [self closeMenu:VPSlideMenuSideRight animated:YES];
    }
}

-(void)setLeftViewController:(UIViewController *)vc collapse:(BOOL) collapse {
    
    [self removeViewController:_leftVC];
    _leftVC = vc;
    [self setViewController:vc toContainer:_leftContainerView];
    
    if (collapse) {
        [self closeMenu:VPSlideMenuSideLeft animated:YES];
    }
}

-(void)setRightViewController:(UIViewController *)vc collapse:(BOOL) collapse {
    
    [self removeViewController:_rightVC];
    _rightVC = vc;
    [self setViewController:vc toContainer:_rightContainerView];
    
    if (collapse) {
        [self closeMenu:VPSlideMenuSideRight animated:YES];
    }
}

#pragma mark - guesture recognizer

-(void)addLeftGestures
{
    if (self.leftVC != nil) {
        
        if(self.panGesturesEnabled && leftPanRecognazer == nil) {
            
            leftPanRecognazer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleLeftPanGesture:)];
            leftPanRecognazer.delegate = self;
            [self.view addGestureRecognizer:leftPanRecognazer];
        }
        
        if(self.tapGesturesEnabled && leftTapRecognazer == nil) {
            
            leftTapRecognazer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(toggleLeftMenu)];
            leftTapRecognazer.delegate = self;
            [self.view addGestureRecognizer:leftTapRecognazer];
            
        }
        
    }
}

-(void)addRightGestures
{
    if (self.rightVC != nil) {
        
        if(self.panGesturesEnabled && rightPanRecognazer == nil) {
            
            rightPanRecognazer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleRightPanGesture:)];
            rightPanRecognazer.delegate = self;
            [self.view addGestureRecognizer:rightPanRecognazer];
        }
        
        if(self.tapGesturesEnabled && rightTapRecognazer == nil) {
            
            rightTapRecognazer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(toggleRightMenu)];
            rightTapRecognazer.delegate = self;
            [self.view addGestureRecognizer:rightTapRecognazer];
            
        }
        
    }
}

-(void)removeLeftGestures {
    
    if(leftPanRecognazer != nil) {
        [self.view removeGestureRecognizer:leftPanRecognazer];
        leftPanRecognazer = nil;
    }
    
    if(leftTapRecognazer != nil) {
        [self.view removeGestureRecognizer:leftTapRecognazer];
        leftTapRecognazer = nil;
    }
}

-(void)removeRightGestures {
    
    if(rightPanRecognazer != nil) {
        [self.view removeGestureRecognizer:rightPanRecognazer];
        rightPanRecognazer = nil;
    }
    
    if(rightTapRecognazer != nil) {
        [self.view removeGestureRecognizer:rightTapRecognazer];
        rightTapRecognazer = nil;
    }
}

-(void) handleLeftPanGesture:(UIPanGestureRecognizer*) panGesture
{
    if([self isRightMenuOpened]) {
        return;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            if (leftPan.lastState == UIGestureRecognizerStateEnded ||
                leftPan.lastState == UIGestureRecognizerStateCancelled ||
                leftPan.lastState == UIGestureRecognizerStateFailed) {
                if(self.delegate) {
                    if ([self isLeftMenuHidden]) {
                        [self.delegate menuWillOpen:VPSlideMenuSideLeft];
                    } else {
                        [self.delegate menuWillClose:VPSlideMenuSideLeft];
                    }
                }
                leftPan.panFrameStarted = _leftContainerView.frame;
                leftPan.panPointStarted = [panGesture locationInView:self.view];
                leftPan.wasOpenAtStart = [self isLeftMenuOpened];
                leftPan.wasHiddenAtStart = [self isLeftMenuHidden];
                [_leftVC beginAppearanceTransition:leftPan.wasHiddenAtStart animated:YES];
                [self closeStatusBar];
            }
            break;
        
        case UIGestureRecognizerStateChanged:
            
            if (leftPan.lastState == UIGestureRecognizerStateBegan ||
                leftPan.lastState == UIGestureRecognizerStateChanged) {
                
                CGPoint translation = [panGesture translationInView:panGesture.view];
                _leftContainerView.frame = [self applyLeftMenuTranslation:translation to:leftPan.panFrameStarted];
            }
            
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (leftPan.lastState == UIGestureRecognizerStateChanged) {
                CGPoint velocity = [panGesture velocityInView:panGesture.view];
                struct PanGuestureDetail panDetail = [self panLeftResultInfoForVelocity:velocity];
                if(panDetail.action == VPSlideMenuActionOpen) {
                    if (!leftPan.wasHiddenAtStart) {
                        [_leftVC beginAppearanceTransition:YES animated:YES];
                    }
                    [self openMenu:VPSlideMenuSideLeft withVelocity:panDetail.velocity];
                } else {
                    if (leftPan.wasHiddenAtStart) {
                        [_leftVC beginAppearanceTransition:NO animated:YES];
                    }
                    [self closeMenu:VPSlideMenuSideLeft withVelocity:panDetail.velocity];
                }
                [self openStatusBar];
            }
            else {
                [self openStatusBar];
            }
            
            break;
        default:
            break;
    }
    
    leftPan.lastState = panGesture.state;
}

-(void) handleRightPanGesture:(UIPanGestureRecognizer*) panGesture {
    
    if([self isLeftMenuOpened]) {
        return;
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            if (rightPan.lastState == UIGestureRecognizerStateEnded ||
                rightPan.lastState == UIGestureRecognizerStateCancelled ||
                rightPan.lastState == UIGestureRecognizerStateFailed) {
                if(self.delegate) {
                    if ([self isRightMenuHidden]) {
                        [self.delegate menuWillOpen:VPSlideMenuSideRight];
                    } else {
                        [self.delegate menuWillClose:VPSlideMenuSideRight];
                    }
                }
                rightPan.panFrameStarted = _rightContainerView.frame;
                rightPan.panPointStarted = [panGesture locationInView:self.view];
                rightPan.wasOpenAtStart = [self isRightMenuOpened];
                rightPan.wasHiddenAtStart = [self isRightMenuHidden];
                [_rightVC beginAppearanceTransition:rightPan.wasHiddenAtStart animated:YES];
                [self closeStatusBar];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            
            if (rightPan.lastState == UIGestureRecognizerStateBegan ||
                rightPan.lastState == UIGestureRecognizerStateChanged) {
                
                CGPoint translation = [panGesture translationInView:panGesture.view];
                _rightContainerView.frame = [self applyRightMenuTranslation:translation to:rightPan.panFrameStarted];
            }
            
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (rightPan.lastState == UIGestureRecognizerStateChanged) {
                CGPoint velocity = [panGesture velocityInView:panGesture.view];
                struct PanGuestureDetail panDetail = [self panRightResultInfoForVelocity:velocity];
                if(panDetail.action == VPSlideMenuActionOpen) {
                    if (!rightPan.wasHiddenAtStart) {
                        [_rightVC beginAppearanceTransition:YES animated:YES];
                    }
                    [self openMenu:VPSlideMenuSideRight withVelocity:panDetail.velocity];
                } else {
                    if (rightPan.wasHiddenAtStart) {
                        [_rightVC beginAppearanceTransition:NO animated:YES];
                    }
                    [self closeMenu:VPSlideMenuSideRight withVelocity:panDetail.velocity];
                }
                [self openStatusBar];
            }
            else {
                [self openStatusBar];
            }
            
            break;
        default:
            break;
    }
    
    rightPan.lastState = panGesture.state;
}


#pragma mark - toggle menu

-(void)openMenu:(VPSlideMenuSide)type animated:(BOOL)animated {
    
    UIViewController *vc = nil;
    UIView *view = nil;
    BOOL isAppearing = YES;
    CGRect frame = CGRectZero;
    if(type == VPSlideMenuSideLeft) {
        vc = _leftVC;
        view = _leftContainerView;
        isAppearing = [self isLeftMenuHidden];
        frame = view.frame;
        frame.origin.x = 0.0;
    }
    else {
        vc = _rightVC;
        view = _rightContainerView;
        isAppearing = [self isRightMenuHidden];
        frame = view.frame;
        frame.origin.x = self.view.bounds.size.width -  view.frame.size.width;
    }
    
    
    if(vc != nil) {
        
        if(self.delegate) {
            [self.delegate menuWillOpen:type];
        }
        [self closeStatusBar];
        if(animated) {
            [vc beginAppearanceTransition:isAppearing animated:YES];
            [self openMenu:type withVelocity:0.0];
        }
        else {
            view.frame = frame;
            _containerView.transform = CGAffineTransformScale(_containerView.transform, 1.0, 1.0);
            [self disableContentInteraction];
            if(self.delegate) {
                [self.delegate menuDidOpened:type];
            }
        }
    }
}

-(void)closeMenu:(VPSlideMenuSide)type animated:(BOOL)animated {
    
    UIViewController *vc = nil;
    UIView *view = nil;
    BOOL isAppearing = YES;
    CGRect frame = CGRectZero;
    if(type == VPSlideMenuSideLeft) {
        vc = _leftVC;
        view = _leftContainerView;
        isAppearing = [self isLeftMenuHidden];
        frame = view.frame;
        frame.origin.x = [self leftMenuOriginForClosedState];
    }
    else {
        vc = _rightVC;
        view = _rightContainerView;
        isAppearing = [self isRightMenuHidden];
        frame = view.frame;
        frame.origin.x = [self rightMenuOriginForClosedState];
    }
    
    
    if(vc != nil) {
        if(self.delegate) {
            [self.delegate menuWillClose:type];
        }
        [self openStatusBar];
        if(animated) {
            [vc beginAppearanceTransition:isAppearing animated:YES];
            [self closeMenu:type withVelocity:0.0];
        }
        else {
            view.frame = frame;
            _containerView.transform = CGAffineTransformScale(_containerView.transform, 1.0, 1.0);
            [self enableContentInteraction];
            if(self.delegate) {
                [self.delegate menuDidClosed:type];
            }
        }
    }
}

-(void) toggleLeftMenu {
    if([self isLeftMenuOpened]) {
        [self closeMenu:VPSlideMenuSideLeft animated:YES];
    } else {
        [self openMenu:VPSlideMenuSideLeft animated:YES];
    }
}

-(BOOL) isLeftMenuOpened {
    return _leftVC != nil && _leftContainerView.frame.origin.x == 0.0;
}

-(BOOL) isLeftMenuHidden {
    return _leftContainerView.frame.origin.x <= [self leftMenuOriginForClosedState];
}


-(void) toggleRightMenu {
    if([self isRightMenuOpened]) {
        [self closeMenu:VPSlideMenuSideRight animated:YES];
    } else {
        [self openMenu:VPSlideMenuSideRight animated:YES];
    }
}

-(BOOL) isRightMenuOpened {
    return _rightVC != nil &&
    _rightContainerView.frame.origin.x == ([self rightMenuOriginForClosedState] - _rightContainerView.frame.size.width);
}

-(BOOL) isRightMenuHidden {
    return _rightContainerView.frame.origin.x >= [self leftMenuOriginForClosedState];
}

#pragma mark - properties

-(void)setMainVC:(UIViewController *)vc
{
    _mainVC = vc;
}

-(void)setLeftVC:(UIViewController *)vc
{
    _leftVC = vc;
}
-(void)setRightVC:(UIViewController *)vc
{
    _rightVC = vc;
}


-(void)setLeftViewWidth:(CGFloat)leftViewWidth {
    _leftViewWidth = leftViewWidth;
    CGRect frame = _leftContainerView.frame;
    frame.size.width = _leftViewWidth;
    frame.origin.x = [self leftMenuOriginForClosedState];
    _leftContainerView.frame = frame;
}

-(void)setLeftAreaWidth:(CGFloat)leftAreaWidth {
    _leftAreaWidth = leftAreaWidth;
}

-(void)setLeftPanEnabled:(BOOL)leftPanEnabled {
    if(_leftPanEnabled != leftPanEnabled) {
        _leftPanEnabled = leftPanEnabled;
    }
}

-(void)setRightViewWidth:(CGFloat)rightViewWidth {
    _rightViewWidth = rightViewWidth;
    CGRect frame = _rightContainerView.frame;
    frame.size.width = _rightViewWidth;
    frame.origin.x = [self rightMenuOriginForClosedState];
    _rightContainerView.frame = frame;
}

-(void)setRightAreaWidth:(CGFloat)rightAreaWidth {
    _rightAreaWidth = rightAreaWidth;
}

-(void)setRightPanEnabled:(BOOL)rightPanEnabled {
    if(_rightPanEnabled != rightPanEnabled) {
        _rightPanEnabled = rightPanEnabled;
    }
}


-(void)setPanGesturesEnabled:(BOOL)panGesturesEnabled {
    if(_panGesturesEnabled != panGesturesEnabled) {
        _panGesturesEnabled = panGesturesEnabled;
    }
}

-(void)setTapGesturesEnabled:(BOOL)tapGesturesEnabled {
    if(_tapGesturesEnabled != tapGesturesEnabled) {
        _tapGesturesEnabled = tapGesturesEnabled;
    }
}

-(void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
}

#pragma mark  - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:self.view];
    
    if(gestureRecognizer == leftPanRecognazer)
    {
        return [self isLeftMenuOpened] || [self shouldReceiveTouchForLeftPanGuestureInPoint:point];
    }
    else if (gestureRecognizer == rightPanRecognazer)
    {
        return [self isRightMenuOpened] || [self shouldReceiveTouchForRightPanGuestureInPoint:point];
    }
    else if (gestureRecognizer == leftTapRecognazer)
    {
        return [self isLeftMenuOpened] && !CGRectContainsPoint(_leftContainerView.frame, point);
    }
    else if (gestureRecognizer == rightTapRecognazer)
    {
        return [self isRightMenuOpened] && !CGRectContainsPoint(_rightContainerView.frame, point);
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) shouldReceiveTouchForLeftPanGuestureInPoint:(CGPoint)point {
    return (self.leftPanEnabled && [self isPointContainedWithinLeftArea:point]);
}

- (BOOL) shouldReceiveTouchForRightPanGuestureInPoint:(CGPoint)point {
    return (self.rightPanEnabled && [self isPointContainedWithinRightArea:point]);
}

-(BOOL)isPointContainedWithinLeftArea:(CGPoint) point {
    if(self.leftAreaWidth > 0)
    {
        CGRect leftRect = CGRectZero;
        CGRect reminder = CGRectZero;
        CGRectDivide(self.view.bounds, &leftRect, &reminder, self.leftAreaWidth, CGRectMinXEdge);
        return CGRectContainsPoint(leftRect, point);
    }
    else
    {
        //if area is not defined then enable pan always
        return true;
    }
}

-(BOOL)isPointContainedWithinRightArea:(CGPoint) point {
    if(self.rightAreaWidth > 0)
    {
        CGRect rightRect = CGRectZero;
        CGRect reminder = CGRectZero;
        CGFloat width = self.view.bounds.size.width - self.rightAreaWidth;
        
        CGRectDivide(self.view.bounds, &reminder, &rightRect, width, CGRectMinXEdge);
        return CGRectContainsPoint(rightRect, point);
    }
    else
    {
        //if area is not defined then enable pan always
        return true;
    }
}


#pragma mark - private

-(void) setViewController:(UIViewController*)viewController toContainer:(UIView*)container {
    
    if(viewController != nil) {
        viewController.view.frame = container.bounds;
        if(![self.childViewControllers containsObject:viewController]) {
            [self addChildViewController:viewController];
            [container addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
        
    }
}

-(void) removeViewController:(UIViewController*)viewController {
    if(viewController != nil) {
        [viewController.view.layer removeAllAnimations];
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
}

-(void) disableContentInteraction {
    _containerView.userInteractionEnabled = NO;
}

-(void) enableContentInteraction {
    _containerView.userInteractionEnabled = YES;
}


#pragma mark - open/close logic

-(void)openMenu:(VPSlideMenuSide)type withVelocity:(CGFloat)velocity {
    
    UIViewController *vc = nil;
    UIView *contentView = nil;
    CGFloat originX = 0.0;
    CGFloat finalX = 0.0;
    NSTimeInterval duration = _animationDuration;
    
    if(type == VPSlideMenuSideLeft) {
        vc = _leftVC;
        contentView = _leftContainerView;
        originX = contentView.frame.origin.x;
    }
    else {
        vc = _rightVC;
        contentView = _rightContainerView;
        originX = _rightContainerView.frame.origin.x;
        finalX = self.view.bounds.size.width - _rightContainerView.frame.size.width;
    }
    
    CGRect frame = contentView.frame;
    frame.origin.x = finalX;
    
    if (velocity > 0) {
        duration = fabs(originX - finalX) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    CGRect rootFrame = _containerView.frame;
    
    if (!_willMenuOverlapMainView) {
        if(type == VPSlideMenuSideLeft) {
            rootFrame.origin.x = finalX + frame.size.width;
        }
        else {
            rootFrame.origin.x = -finalX;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            contentView.frame = frame;
            strongSelf.containerView.frame = rootFrame;
            strongSelf.containerView.transform = CGAffineTransformScale(strongSelf.containerView.transform, 1.0, 1.0);
        }
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf disableContentInteraction];
            [vc endAppearanceTransition];
            if(strongSelf.delegate) {
                [strongSelf.delegate menuDidOpened:type];
            }
        }
    }];
}


-(void)closeMenu:(VPSlideMenuSide)type withVelocity:(CGFloat)velocity {
    
    UIViewController *vc = nil;
    UIView *contentView = nil;
    CGFloat originX = 0.0;
    CGFloat finalX = 0.0;
    NSTimeInterval duration = _animationDuration;
    
    if(type == VPSlideMenuSideLeft) {
        vc = _leftVC;
        contentView = _leftContainerView;
        originX = _leftContainerView.frame.origin.x;
        finalX = [self leftMenuOriginForClosedState];
    }
    else {
        vc = _rightVC;
        contentView = _rightContainerView;
        originX = _rightContainerView.frame.origin.x;
        finalX = [self rightMenuOriginForClosedState];
    }
    
    CGRect frame = contentView.frame;
    frame.origin.x = finalX;
    
    if (velocity > 0) {
        duration = fabs(originX - finalX) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    CGRect rootFrame = self.view.frame;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            contentView.frame = frame;
            strongSelf.containerView.frame = rootFrame;
            strongSelf.containerView.transform = CGAffineTransformScale(strongSelf.containerView.transform, 1.0, 1.0);
        }
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf enableContentInteraction];
            [vc endAppearanceTransition];
            if(strongSelf.delegate) {
                [strongSelf.delegate menuDidClosed:type];
            }
        }
    }];
}

#pragma mark - pan gesture helpers

-(CGRect) applyLeftMenuTranslation: (CGPoint) translation to:(CGRect)frame {
    
    CGFloat newOrigin = frame.origin.x;
    newOrigin += translation.x;
    
    CGFloat minOrigin = [self leftMenuOriginForClosedState];
    CGFloat maxOrigin = 0.0;
    CGRect newFrame = frame;
    
    newFrame.origin.x = fmin(maxOrigin, fmax(minOrigin, newOrigin));
    return newFrame;
}

-(CGRect) applyRightMenuTranslation: (CGPoint) translation to:(CGRect)frame {
    
    CGFloat newOrigin = frame.origin.x;
    newOrigin += translation.x;
    
    CGFloat maxOrigin = [self rightMenuOriginForClosedState];
    CGFloat minOrigin = [self rightMenuOriginForClosedState] - _rightContainerView.frame.size.width;
    CGRect newFrame = frame;
    
    newFrame.origin.x = fmin(maxOrigin, fmax(minOrigin, newOrigin));
    return newFrame;
}


-(struct PanGuestureDetail) panLeftResultInfoForVelocity: (CGPoint) velocity {
    CGFloat thresholdVelocity = 1000.0;
    CGFloat borderPoint = (CGFloat)floor([self leftMenuOriginForClosedState]) + _minPanWidth;
    CGFloat leftOrigin = _leftContainerView.frame.origin.x;
    
    struct PanGuestureDetail detail;
    detail.velocity = 0.0;
    detail.action = (leftOrigin <= borderPoint) ? VPSlideMenuActionClose : VPSlideMenuActionOpen;
    
    if (velocity.x >= thresholdVelocity) {
        detail.action = VPSlideMenuActionOpen;
        detail.velocity = velocity.x;
    } else if (velocity.x <= (-1.0 * thresholdVelocity)) {
        detail.action = VPSlideMenuActionClose;
        detail.velocity = velocity.x;
    }
    return detail;
}

-(struct PanGuestureDetail) panRightResultInfoForVelocity: (CGPoint) velocity {
    CGFloat thresholdVelocity = -1000.0;
    CGFloat borderPoint = (CGFloat)floor([self rightMenuOriginForClosedState]) - _minPanWidth;
    CGFloat rightOrigin = _rightContainerView.frame.origin.x;
    
    struct PanGuestureDetail detail;
    detail.velocity = 0.0;
    detail.action = (rightOrigin >= borderPoint) ? VPSlideMenuActionClose : VPSlideMenuActionOpen;
    
    if (velocity.x <= thresholdVelocity) {
        detail.action = VPSlideMenuActionOpen;
        detail.velocity = velocity.x;
    } else if (velocity.x >= (-1.0 * thresholdVelocity)) {
        detail.action = VPSlideMenuActionClose;
        detail.velocity = velocity.x;
    }
    return detail;
}

#pragma mark - status bar

-(void)closeStatusBar {
    if(_hideStatusBar) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            if(window) {
                window.windowLevel = UIWindowLevelStatusBar + 1; //above status bar
            }
        });
    }
}

-(void)openStatusBar {
    if(_hideStatusBar) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            if(window) {
                window.windowLevel = UIWindowLevelNormal;
            }
        });
    }
}

@end
