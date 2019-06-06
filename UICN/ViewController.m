//
//  ViewController.m
//  UICN
//
//  Created by herui on 2019/6/5.
//  Copyright © 2019 ifensi. All rights reserved.
//

#import "ViewController.h"
#import "HHAnimationLoaingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    HHAnimationLoaingView *loadingView = [[HHAnimationLoaingView alloc] initWithFrame:CGRectMake(0, 0, kAnimationLoaingViewWidth, kAnimationLoaingViewHeight)];
    [self.view addSubview:loadingView];
    loadingView.center = self.view.center;
}





@end
