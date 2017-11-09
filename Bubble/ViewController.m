//
//  ViewController.m
//  Bubble
//
//  Created by JuFan  on 2017/11/7.
//  Copyright © 2017年 Jasion. All rights reserved.
//

#import "ViewController.h"
#import "UIDragButton.h"
#import "FloatWindow.h"

@interface ViewController ()<CALayerDelegate,UIDragButtonDelegate>
{
    UIButton *view1;
}

@property (nonatomic, strong) UIDragButton *button;
@property (nonatomic, strong) FloatWindow *window;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    view1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 77, 81)];
//    //圆角设置
//    view1.layer.masksToBounds = YES;
//    //view1.layer.cornerRadius = 20;
//    [view1 setBackgroundImage:[UIImage imageNamed:@"loan"] forState:UIControlStateNormal];
//    //view1.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view1];
//    [self AddAniamtionLikeGameCenterBubble];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initSubview];
}

- (void)initSubview
{
    [self.view addSubview:self.window];
    //[self AddAniamtionLikeGameCenterBubble];
}

- (UIDragButton *)button
{
    if (!_button) {
        // 悬浮按钮
        _button = [UIDragButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:@"loan"] forState:UIControlStateNormal];
        // 按钮图片伸缩充满整个按钮
        _button.imageView.contentMode = UIViewContentModeScaleToFill;
        _button.frame = CGRectMake(0, 0, 77, 81);
        // 按钮点击事件
        [_button addTarget:self action:@selector(floatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        // 初始选中状态
        _button.selected = NO;
        // 禁止高亮
        _button.adjustsImageWhenHighlighted = NO;
        _button.rootView = self.view.superview;
        _button.btnDelegate = self;
        _button.imageView.alpha = 0.8;
    }
    return _button;
}

- (FloatWindow *)window{
    if (!_window) {
        // 悬浮窗
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        
        _window = [[FloatWindow alloc] init];
        _window.floatFrame = CGRectMake(width-77, height-50-64, 77, 81);
        _window.windowLevel = UIWindowLevelAlert+1;
        _window.backgroundColor = [UIColor clearColor];
        //_window.layer.cornerRadius = 60/2;
        _window.layer.masksToBounds = YES;
        // 将按钮添加到悬浮按钮上
        [_window addSubview:self.button];
        //显示window
        [_window makeKeyAndVisible];
    }
    return _window;
}

/**
 *  悬浮按钮点击
 */
- (void)floatBtnClicked:(UIButton *)sender
{
    NSLog(@"------");
    
    // 按钮选中关闭切换
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSLog(@"点击----");
        //[sender setImage:[UIImage imageNamed:@"day"] forState:UIControlStateNormal];
    }else{
        //[sender setImage:[UIImage imageNamed:@"day"] forState:UIControlStateNormal];
    }
    // 关闭悬浮窗
    //    [_window resignKeyWindow];
    //    _window = nil;
    
}

- (void)dragButtonClicked:(UIButton *)sender {
    
    NSLog(@"-----");
//    if (_showLoanMarket) {
//        UIApplication *app = [UIApplication sharedApplication];
//        //BOOL result = [app canOpenURL:[NSURL URLWithString:@"lsm://"]];
//        if ([app respondsToSelector:@selector(openURL:options:completionHandler:)]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"lsm://"] options:@{} completionHandler:^(BOOL success) {
//                if (success) {
//                    //[self pushWebControllerWithURLPath:self.loanMarketUrl navTitle:self.loanMarketTitle];
//                }else{
//                    [self pushWebControllerWithURLPath:self.loanMarketUrl navTitle:self.loanMarketTitle];
//                }
//            }];
//        }else{
//            BOOL sucess = [app openURL:[NSURL URLWithString:@"lsm://"]];
//            if (sucess == NO) {
//                [self pushWebControllerWithURLPath:self.loanMarketUrl navTitle:self.loanMarketTitle];
//            }
//        }
//    }
    
}

-(void)AddAniamtionLikeGameCenterBubble
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;  //动画均匀进行
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    //线性运动
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    //除了xy方向的扩大缩小，泡泡的位置按椭圆形轨迹运动
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    //    CGRect circleContainer = CGRectInset(view1.frame, view1.bounds.size.width / 2 -10, view1.bounds.size.width / 2 -5);
    CGRect circleContainer = CGRectMake(self.button.center.x, self.button.center.y, 10, 5);
    //该方法 会按给定rect搞出一个内切圆出来，可以是椭圆
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    pathAnimation.path = curvedPath;
    //在上面通过creat创建出来的，需要释放
    CGPathRelease(curvedPath);
    [self.button.layer addAnimation:pathAnimation forKey:@"CircleAnimation"];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    //无线循环
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    //运动时间函数 这个是先快后慢再快
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.button.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.button.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
    
}
- (void)tapAction:(UITapGestureRecognizer *)noti{
    
    CGPoint locationInView = [noti locationInView:self.view];
    //presentationLayer layer的动画层
    CALayer *layer1=[[view1.layer presentationLayer] hitTest:locationInView];
    if (layer1!=nil) {
        NSLog(@"点击了运动的layer");
    }
    NSLog(@"1111");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
