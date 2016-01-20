//
//  ViewController.m
//  StopwatchApp
//
//  Created by gmmikan on 2016/01/14.
//  Copyright © 2016年 shunsuke.mikawa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    // タイマーインスタンス
    NSTimer *timer;
    
    // 開始時刻
    NSDate *startTime;
    
    // 停止時刻
    NSDate *stopTime;
    
    // 再開時刻
    NSDate *restartTime;
    
    // 稼動時間
    NSTimeInterval interval;
    
    // 停止時間
    NSTimeInterval stopInterval;
    
    // スタート／ストップボタン
    UIButton *timerButton;
    
    // リセットボタン
    UIButton *resetButton;
    
    // 時刻ラベル
    UILabel *timerLabel;
    
    // 背景画像
    UIImageView *backgroundView;
}
@end

@implementation ViewController

- (void)stopTimer {
    // タイマーインスタンスを破棄
    [timer invalidate];
    timer = nil;
    stopTime = [NSDate date];
    [timerButton setTitle:@"スタート" forState:UIControlStateNormal];

    NSLog(@"TIMER IS STOPED");
}

- (void)startTimer {
    // タイマーインスタンスを作成
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    if (startTime == nil) {
        startTime = [NSDate date];
    } else {
        restartTime = [NSDate date];
    }
    [timerButton setTitle:@"ストップ" forState:UIControlStateNormal];
    
    NSLog(@"TIMER IS STARTED");
}

- (void)changeTimer:(id)sender {
    if (timer != nil && [timer isValid]) {
        [self stopTimer];
    } else {
        [self startTimer];
    }
}

- (void)resetTimer:(id)sender {
    [self stopTimer];
    startTime = nil;
    stopTime = nil;
    restartTime = nil;
    interval = 0;
    stopInterval = 0;
    timerLabel.text = @"00:00";

    NSLog(@"TIMER IS RESETED");
}

- (void)tick:(NSTimer*)timer {
    // 再開までの停止時間を計算
    if (stopTime != nil) {
        stopInterval = [restartTime timeIntervalSinceDate: stopTime] + stopInterval;
        stopTime = nil;
        restartTime = nil;
    }
    
    // 稼働時間を計算
    interval = [[NSDate date] timeIntervalSinceDate: startTime];
    int minute = fmod((interval - stopInterval) / 60, 60);
    int second = fmod((interval - stopInterval), 60);
    NSString *dateStr = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    [timerLabel setText:dateStr];
    
    NSLog(@"TIMER IS RUNNING");
}

- (void)setupParts {
    // 背景画像
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    backgroundView.image = [UIImage imageNamed:@"568.jpeg"];
    [self.view addSubview:backgroundView];
    
    // スタート／ストップボタン
    timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timerButton.frame = CGRectMake(100.0f, 150.0f, 100.0f, 30.0f);
    timerButton.center = CGPointMake(80, 400);
    [timerButton setBackgroundColor:[UIColor lightGrayColor]];
    [timerButton.layer setCornerRadius:10.0];
    [timerButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [timerButton.layer setBorderWidth:1.0];
    [timerButton setTitle:@"スタート" forState:UIControlStateNormal];
    [timerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [timerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [timerButton addTarget:self action:@selector(changeTimer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timerButton];
    
    // リセットボタン
    resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.frame = CGRectMake(100.0f, 150.0f, 100.0f, 30.0f);
    resetButton.center = CGPointMake(240, 400);
    [resetButton setBackgroundColor:[UIColor lightGrayColor]];
    [resetButton.layer setCornerRadius:10.0];
    [resetButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [resetButton.layer setBorderWidth:1.0];
    [resetButton setTitle:@"リセット" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [resetButton addTarget:self action:@selector(resetTimer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
    
    // 時刻ラベル
    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    timerLabel.center = CGPointMake(160, 284);
    timerLabel.font = [UIFont fontWithName:@"HirakakuProN-W6" size:48];
    timerLabel.text = @"00:00";
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:timerLabel];
    
    // 稼働時間と停止時間を初期化
    interval = 0;
    stopInterval = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupParts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
