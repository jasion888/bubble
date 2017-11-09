//
//  UIDragButton.m
//  BtnDemo
//
//  Created by More on 16/11/24.
//  Copyright © 2016年 More. All rights reserved.
//
// 屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width


#import "UIDragButton.h"
#import "AppDelegate.h"

@interface UIDragButton()

@property(nonatomic,assign)CGPoint startPos;

@end

@implementation UIDragButton

// 枚举四个吸附方向
typedef enum {
    LEFT,
    RIGHT,
    TOP,
    BOTTOM
}Dir;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self AddAniamtionLikeGameCenterBubble];
}

/**
 *  开始触摸，记录触点位置用于判断是拖动还是点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    _startPos = [touch locationInView:_rootView];
}

/**
 *  手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 移动按钮到当前触摸位置
    self.superview.center = curPoint;
}

/**
 *  拖动结束后使悬浮窗口吸附在最近的屏幕边缘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 通知代理,如果结束触点和起始触点极近则认为是点击事件
    if (pow((_startPos.x - curPoint.x),2) + pow((_startPos.y - curPoint.y),2) < 1) {
        [self.btnDelegate dragButtonClicked:self];
        // 点击后不吸附
        return;
    }

    CGFloat left = curPoint.x;
    CGFloat right = ScreenW - curPoint.x;
    CGFloat top = curPoint.y;
    CGFloat bottom = ScreenH - curPoint.y;
    // 计算四个距离最小的吸附方向
    Dir minDir = LEFT;
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        minDir = RIGHT;
    }
    if (top < minDistance) {
        minDistance = top;
        minDir = TOP;
    }
    if (bottom < minDistance) {
        minDir = BOTTOM;
    }
    
    // 开始吸附
    switch (minDir) {
        case LEFT:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.frame.size.width/2, self.superview.center.y);
                //[self AddAniamtionLikeGameCenterBubble];
            }];
            break;
        }
        case RIGHT:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(ScreenW - self.superview.frame.size.width/2, self.superview.center.y);
                //[self AddAniamtionLikeGameCenterBubble];
            }];
            break;
        }
        case TOP:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.center.x, self.superview.frame.size.height/2);
                //[self AddAniamtionLikeGameCenterBubble];
            }];
            break;
        }
        case BOTTOM:
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.superview.center = CGPointMake(self.superview.center.x, ScreenH - self.superview.frame.size.height/2);
                //[self AddAniamtionLikeGameCenterBubble];
            }];
            break;
        }
        default:
            break;
    }
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
    CGRect circleContainer = CGRectMake(self.center.x-5, self.center.y, 10, 5);
    //该方法 会按给定rect搞出一个内切圆出来，可以是椭圆
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    pathAnimation.path = curvedPath;
    //在上面通过creat创建出来的，需要释放
    CGPathRelease(curvedPath);
    [self.layer addAnimation:pathAnimation forKey:@"CircleAnimation"];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    //无线循环
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    //运动时间函数 这个是先快后慢再快
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}

@end
