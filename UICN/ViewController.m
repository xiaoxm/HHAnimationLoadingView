//
//  ViewController.m
//  UICN
//
//  Created by herui on 2019/6/5.
//  Copyright © 2019 ifensi. All rights reserved.
//

#import "ViewController.h"
#import "HHAnimationLoaingView.h"
#import "MyAnimationLoadingView.h"

@interface ViewController ()

//@property (nonatomic, weak) CAShapeLayer *U_layer;
//@property (nonatomic, weak) CAShapeLayer *I_layer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   

    MyAnimationLoadingView *animView = [[MyAnimationLoadingView alloc] initWithFrame:CGRectMake(0, 0, 32, 25)];
    [self.view addSubview:animView];
    animView.center = self.view.center;

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    HHAnimationLoaingView *loadingView = [[HHAnimationLoaingView alloc] initWithFrame:CGRectMake(0, 0, kAnimationLoaingViewWidth, kAnimationLoaingViewHeight)];
//    [self.view addSubview:loadingView];
//    loadingView.center = self.view.center;
}





@end
