//
//  XFViewController.m
//  XFSourceTimer
//
//  Created by Aron1987@126.com on 11/09/2020.
//  Copyright (c) 2020 Aron1987@126.com. All rights reserved.
//

#import "XFViewController.h"
#import <XFSourceTimer/XFSourceTimer.h>

static NSInteger s_normal_index = 0;
static NSInteger s_auto_index = 0;

@interface XFViewController ()

@property (nonatomic, strong) XFSourceTimer *normalTimer;
@property (nonatomic, strong) XFSourceTimer *autoTimer;

@property (nonatomic, strong) UIButton *normalButton;
@property (nonatomic, strong) UIButton *autoButton;

@end

@implementation XFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake((self.view.frame.size.width - 80)/2, 100, 80, 40)];
    [button setTitle:@"普通定时器" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onNormalTimerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.normalButton = button;
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button3 setFrame:CGRectMake(20, 200, 80, 40)];
    [button3 setTitle:@"开启定时器" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(onStartTimerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button4 setFrame:CGRectMake((self.view.frame.size.width - 80)/2, 200, 80, 40)];
    [button4 setTitle:@"暂停定时器" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(onSuspendTimerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button5 setFrame:CGRectMake(self.view.frame.size.width - 100, 200, 80, 40)];
    [button5 setTitle:@"停止定时器" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(onStopTimerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];

    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setFrame:CGRectMake((self.view.frame.size.width - 80)/2, 300, 80, 40)];
    [button2 setTitle:@"自动定时器" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(onAutoTimerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    self.autoButton = button2;
    
}

#pragma mark - Action

- (void)onNormalTimerAction:(id)sender {
    self.normalTimer = [XFSourceTimer timerWithTimeInterval:1.0 repeats:YES block:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            s_normal_index++;
            NSString *title = [NSString stringWithFormat:@"%ld", (long)s_normal_index];
            [self.normalButton setTitle:title forState:UIControlStateNormal];
            NSLog(@"=-=-=-%@", title);
        });
    }];
    [self.normalButton setTitle:[NSString stringWithFormat:@"%ld", (long)s_normal_index] forState:UIControlStateNormal];
//    NSLog(@"=-=-=-普通定时器：创建完毕，等待开启");
}

- (void)onAutoTimerAction:(id)sender {
    self.autoTimer = [XFSourceTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            s_auto_index++;
            NSString *title = [NSString stringWithFormat:@"%ld", (long)s_auto_index];
            [self.autoButton setTitle:title forState:UIControlStateNormal];
            NSLog(@"******%@", title);
        });
    }];
    NSLog(@"******自动定时器：创建完毕，已经开启");
}

- (void)onStartTimerAction:(id)sender {
    if (self.normalTimer) {
        [self.normalTimer resumeTimer];
        NSLog(@"=-=-=-普通定时器：开启！");
    }
    if (self.autoTimer) {
        [self.autoTimer resumeTimer];
        NSLog(@"******自动定时器：开启！");
    }
}

- (void)onSuspendTimerAction:(id)sender {
    if (self.normalTimer) {
        [self.normalTimer suspendTimer];
        NSLog(@"=-=-=-普通定时器：暂停！");
    }
    if (self.autoTimer) {
        [self.autoTimer suspendTimer];
        NSLog(@"******自动定时器：暂停！");
    }
}

- (void)onStopTimerAction:(id)sender {
    if (self.normalTimer) {
        [self.normalTimer stopTimer];
        NSLog(@"=-=-=-普通定时器：停止！");
        [self.normalButton setTitle:@"普通定时器" forState:UIControlStateNormal];
        s_normal_index = 0;
    }
    if (self.autoTimer) {
        [self.autoTimer stopTimer];
        NSLog(@"******自动定时器：停止！");
        [self.autoButton setTitle:@"自动定时器" forState:UIControlStateNormal];
        s_auto_index = 0;
    }
}

@end
