//
//  HHAnimationLoaingView.m
//  UICN
//
//  Created by herui on 2019/6/6.
//  Copyright © 2019 ifensi. All rights reserved.
//

#import "HHAnimationLoaingView.h"

const CGFloat kAnimationLoaingViewRadius = 8;
const CGFloat kAnimationLoaingViewWidth = 32;
const CGFloat kAnimationLoaingViewHeight = 25;
const CGFloat kAnimationLoaingViewLineWidth = 5;


@interface HHAnimationLoaingView()

@property (nonatomic, weak) CAShapeLayer *U_layer;
@property (nonatomic, weak) CAShapeLayer *I_layer;


@end

@implementation HHAnimationLoaingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self anim_start];
    }
    return self;
}

- (void)anim_start
{
    [self anim_U];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self anim_I];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self anim_reset];
        });
    });
}



- (void)anim_U
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, kAnimationLoaingViewRadius)];
    [path addLineToPoint:CGPointMake(0, kAnimationLoaingViewHeight-kAnimationLoaingViewRadius)];
    [path addArcWithCenter:CGPointMake(kAnimationLoaingViewRadius, kAnimationLoaingViewHeight-kAnimationLoaingViewRadius) radius:kAnimationLoaingViewRadius startAngle:M_PI endAngle:0 clockwise:NO];
    [path addLineToPoint:CGPointMake(kAnimationLoaingViewRadius*2, kAnimationLoaingViewRadius)];
    
    self.U_layer.path = path.CGPath;
    
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0;
    strokeEndAnimation.toValue = @1;
    strokeEndAnimation.duration = 1.f;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.U_layer removeAllAnimations];
    [self.U_layer addAnimation:strokeEndAnimation forKey:@"strokeAnimation"];
}

- (void)anim_I
{
    //I在这里其实是一个倒过来的U,但是最终只显示右侧的竖线（注掉addAnimation:就能看出来）
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(kAnimationLoaingViewRadius, kAnimationLoaingViewHeight-kAnimationLoaingViewRadius)];
    [path addLineToPoint:CGPointMake(kAnimationLoaingViewRadius, kAnimationLoaingViewRadius)];
    [path addArcWithCenter:CGPointMake(kAnimationLoaingViewRadius * 2, kAnimationLoaingViewRadius) radius:kAnimationLoaingViewRadius startAngle:M_PI endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(kAnimationLoaingViewRadius * 3, kAnimationLoaingViewHeight)];
    
    self.I_layer.path = path.CGPath;
    
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0;
    strokeEndAnimation.toValue = @1;
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @0;
    strokeStartAnimation.toValue = @(1 - ((kAnimationLoaingViewHeight-kAnimationLoaingViewRadius) / ((kAnimationLoaingViewHeight-kAnimationLoaingViewRadius) + (M_PI * kAnimationLoaingViewRadius) + (kAnimationLoaingViewHeight - (kAnimationLoaingViewRadius * 2)))));
    strokeStartAnimation.fillMode = kCAFillModeForwards;
    strokeStartAnimation.removedOnCompletion = NO;
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeEndAnimation, strokeStartAnimation];
    animationGroup.duration = 0.5;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    
    [self.I_layer removeAllAnimations];
    [self.I_layer addAnimation:animationGroup forKey:@"animation"];
    
}

- (void)anim_reset
{
    //平移消失
    CGPoint position = self.U_layer.position;
    position.x -= kAnimationLoaingViewWidth;
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.values = @[[NSValue valueWithCGPoint:self.U_layer.position],
                             [NSValue valueWithCGPoint:position]];

    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1,@1,@1,@1,@1,@1,@0];

    {
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[moveAnimation, opacityAnimation];
        animationGroup.duration = 0.5;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        [self.I_layer addAnimation:animationGroup forKey:@"strokeAnimation"];
    }
    

    //U变回一个点
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.U_layer.path];
    [path moveToPoint:CGPointMake(kAnimationLoaingViewRadius * 2, kAnimationLoaingViewRadius)];
    [path addArcWithCenter:CGPointMake(kAnimationLoaingViewRadius * 3, kAnimationLoaingViewRadius) radius:kAnimationLoaingViewRadius startAngle:M_PI endAngle:0 clockwise:YES];

    self.U_layer.path = path.CGPath;

    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    CGFloat len = ((kAnimationLoaingViewHeight-(kAnimationLoaingViewRadius * 2) * 2) + (M_PI * kAnimationLoaingViewRadius) * 2);
    strokeEndAnimation.fromValue = @(((M_PI * kAnimationLoaingViewRadius) /  len) + (2.5 / len));
    strokeEndAnimation.toValue = @1;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @0;
    strokeStartAnimation.toValue = @(1);
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeEndAnimation, strokeStartAnimation, moveAnimation];
    animationGroup.duration = 0.5;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;

    [self.U_layer addAnimation:animationGroup forKey:@"strokeAnimation"];

    //循环，
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self anim_start];
    });
}


#pragma mark - getter methods
- (CAShapeLayer *)U_layer
{
    if(!_U_layer){
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.bounds = self.bounds;
        layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor colorWithRed:55/255.0 green:115/255.0  blue:252/255.0 alpha:1].CGColor;
        layer.lineWidth = kAnimationLoaingViewLineWidth;
        layer.lineCap = kCALineCapRound;//线头圆角
        layer.lineJoin = kCALineJoinRound;//拐角处圆角
        _U_layer = layer;
    }
    
    if(!_U_layer.superlayer){
        [self.layer addSublayer:_U_layer];
    }
    return _U_layer;
}

- (CAShapeLayer *)I_layer
{
    if(!_I_layer){
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.bounds = self.bounds;
        layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor colorWithRed:55/255.0 green:115/255.0  blue:252/255.0 alpha:1].CGColor;
        layer.lineWidth = kAnimationLoaingViewLineWidth;
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        _I_layer = layer;
    }
    
    if(!_I_layer.superlayer){
        [self.layer addSublayer:_I_layer];
    }
    return _I_layer;
}



@end
