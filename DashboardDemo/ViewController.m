//
//  ViewController.m
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import "ViewController.h"
#import "DashboardView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)

@interface ViewController ()

@property (nonatomic, strong) DashboardView *dashboardView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, assign) CGFloat progress;

@end

@implementation ViewController

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(20, kScreenHeight - 60, kScreenWidth - 40, 20)];
        _slider.minimumTrackTintColor = [UIColor greenColor];
        _slider.maximumTrackTintColor = [UIColor redColor];
        _slider.value = 0;
        [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (DashboardView *)dashboardView {
    if (!_dashboardView) {
        CGFloat baseViewWidth = (kScreenHeight - 154)/2;
        CGFloat baseViewHeight = baseViewWidth;
        CGFloat baseViewX = (kScreenWidth - baseViewWidth)/2;
        CGFloat baseViewY = 74;
        _dashboardView = [[DashboardView alloc] initWithFrame:CGRectMake(baseViewX, baseViewY, baseViewWidth, baseViewHeight)];
    }
    return _dashboardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.dashboardView];
    [self.view addSubview:self.slider];
}

- (void)animateWithProgress:(CGFloat)progress {
    CGFloat angle = (progress - 0.5) * DEGREES_TO_RADIANS(270);
    [UIView animateWithDuration:1 animations:^{
        self.dashboardView.pointerView.transform = CGAffineTransformMakeRotation(angle);
        self.dashboardView.infoLabel.text = [NSString stringWithFormat:@"%.1f", progress * 2400];
    }];
}

- (void)sliderChange:(UISlider *)slider {
    self.progress = slider.value;
    [self animateWithProgress:self.progress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
