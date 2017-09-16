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
};

@interface VPSlideMenuViewController ()<UIGestureRecognizerDelegate>
{
    UIView *containerView;
    UIView *containerOpacityView;
    UIView *leftContainerView;
    UIView *rightContainerView;
    
    UIPanGestureRecognizer *leftPanRecognazer;
    UIPanGestureRecognizer *rightPanRecognazer;
    
    UITapGestureRecognizer *leftTapRecognazer;
    UITapGestureRecognizer *rightTapRecognazer;
    
}

@property (nonatomic, strong) UIViewController *mainVC;
@property (nonatomic, strong) UIViewController *leftVC;
@property (nonatomic, strong) UIViewController *rightVC;


@end

@implementation VPSlideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    NSLog(@"VPSlideMenuViewController dealloc");
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupDefaultValues];
    [self initView];
    
}

#pragma mark - init

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
        [self initView];
    }
    return self;
}

-(void)setupDefaultValues
{
     _leftViewWidth = 100;
     _leftAreaWidth = 0;
     _leftPanEnabled = YES;
    
     _rightViewWidth = 100;
     _rightAreaWidth = 0;
     _rightPanEnabled = YES;
    
     _panGesturesEnabled = YES;
     _tapGesturesEnabled = YES;
}

- (void) initView {
    containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:containerView atIndex:0];
    
    if(self.leftVC != nil) {
        
        CGRect frame = self.view.bounds;
        frame.size.width = _leftViewWidth;
        frame.origin.x = [self leftMenuOriginForClosedState];
        
        leftContainerView = [[UIView alloc] initWithFrame:frame];
        leftContainerView.backgroundColor = [UIColor clearColor];
        leftContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:leftContainerView];
    }
    
    if(self.rightVC != nil) {
        
        CGRect frame = self.view.bounds;
        frame.size.width = _rightViewWidth;
        frame.origin.x = [self rightMenuOriginForClosedState];
        
        rightContainerView = [[UIView alloc] initWithFrame:frame];
        rightContainerView.backgroundColor = [UIColor clearColor];
        rightContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:rightContainerView];
    }
}

- (CGFloat) leftMenuOriginForClosedState {
    return  -self.leftViewWidth;
}

- (CGFloat) rightMenuOriginForClosedState {
    return  self.view.bounds.size.width;
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

-(void) handleLeftPanGesture:(UIPanGestureRecognizer*) panGesture {
}

-(void) handleRightPanGesture:(UIPanGestureRecognizer*) panGesture {
}


#pragma mark - toggle menu

-(void) toggleLeftMenu {
    if([self isLeftMenuOpened]) {
       // [self closeLeft];
    } else {
        //[self openLeft];
    }
}

-(BOOL) isLeftMenuOpened {
    return _leftVC != nil && leftContainerView.frame.origin.x == 0.0;
}

-(BOOL) isLeftMenuHidden {
    return leftContainerView.frame.origin.x <= [self leftMenuOriginForClosedState];
}


-(void) toggleRightMenu {
    if([self isRightMenuOpened]) {
        // [self closeLeft];
    } else {
        //[self openLeft];
    }
}

-(BOOL) isRightMenuOpened {
    return _rightVC != nil &&
    rightContainerView.frame.origin.x == ([self rightMenuOriginForClosedState] - rightContainerView.frame.size.width);
}

-(BOOL) isrightMenuHidden {
    return rightContainerView.frame.origin.x >= [self leftMenuOriginForClosedState];
}

#pragma mark - properties

-(void)setLeftViewWidth:(CGFloat)leftViewWidth {
    _leftViewWidth = leftViewWidth;
    CGRect frame = leftContainerView.frame;
    frame.size.width = _leftViewWidth;
    frame.origin.x = [self leftMenuOriginForClosedState];
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
    CGRect frame = rightContainerView.frame;
    frame.size.width = _rightViewWidth;
    frame.origin.x = [self rightMenuOriginForClosedState];
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
        return [self isLeftMenuOpened] && !CGRectContainsPoint(leftContainerView.frame, point);
    }
    else if (gestureRecognizer == rightTapRecognazer)
    {
        return [self isRightMenuOpened] && !CGRectContainsPoint(rightContainerView.frame, point);
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


@end
