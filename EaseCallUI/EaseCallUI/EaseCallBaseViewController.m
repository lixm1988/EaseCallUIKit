//
//  EaseCallBaseViewController.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallBaseViewController.h"
#import "EaseCallManager+Private.h"
#import <Masonry/Masonry.h>
#import "UIImage+Ext.h"

@interface EaseCallBaseViewController ()
@property (nonatomic, assign) int timeLength;
@end

@implementation EaseCallBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setubSubViews];
}

- (void)setubSubViews
{
    int size = 40;
    self.hangupButton = [[UIButton alloc] init];
    self.hangupButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.hangupButton setImage:[UIImage imageNamedFromBundle:@"hangup"] forState:UIControlStateNormal];
    [self.hangupButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hangupButton];
    [self.hangupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-40);
        make.left.equalTo(@30);
        make.width.height.equalTo(@60);
    }];
    
    self.answerButton = [[UIButton alloc] init];
    self.answerButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.answerButton setImage:[UIImage imageNamedFromBundle:@"answer"] forState:UIControlStateNormal];
    [self.answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.answerButton];
    [self.answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hangupButton);
        make.right.equalTo(self.view).offset(-40);
        make.width.height.mas_equalTo(60);
    }];
    
    self.switchCameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.switchCameraButton setTintColor:[UIColor whiteColor]];
    [self.switchCameraButton setImage:[UIImage imageNamedFromBundle:@"switchCamera"] forState:UIControlStateNormal];
    [self.switchCameraButton setImage:[UIImage imageNamedFromBundle:@"switchCamera"] forState:UIControlStateSelected];
    [self.switchCameraButton addTarget:self action:@selector(switchCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchCameraButton];
    [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hangupButton.mas_top).offset(-40);
        //make.left.equalTo(@30);
        make.centerX.equalTo(self.view).with.multipliedBy(0.3);
        make.width.height.equalTo(@(size));
    }];
    
    self.speakerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.speakerButton setTintColor:[UIColor whiteColor]];
    [self.speakerButton setImage:[UIImage imageNamedFromBundle:@"speaker_gray"] forState:UIControlStateNormal];
    [self.speakerButton setImage:[UIImage imageNamedFromBundle:@"speaker_white"] forState:UIControlStateSelected];
    [self.speakerButton addTarget:self action:@selector(speakerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.speakerButton];
    [self.speakerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.switchCameraButton);
        //make.left.equalTo(self.switchCameraButton.mas_right).offset(40);
        make.centerX.equalTo(self.view).with.multipliedBy(0.7);
        make.width.height.equalTo(@(size));
    }];
    
    self.microphoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.microphoneButton setTintColor:[UIColor whiteColor]];
    [self.microphoneButton setImage:[UIImage imageNamedFromBundle:@"micphone_white"] forState:UIControlStateNormal];
    [self.microphoneButton setImage:[UIImage imageNamedFromBundle:@"micphone_gray"] forState:UIControlStateSelected];
    [self.microphoneButton addTarget:self action:@selector(muteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.microphoneButton];
    [self.microphoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(self.speakerButton.mas_right).offset(40);
        make.centerX.equalTo(self.view).with.multipliedBy(1.2);
        make.bottom.equalTo(self.switchCameraButton);
        make.width.height.equalTo(@(size));
    }];
    self.microphoneButton.selected = YES;

    self.enableCameraButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.enableCameraButton setTintColor:[UIColor whiteColor]];
    [self.enableCameraButton setImage:[UIImage imageNamedFromBundle:@"video_white"] forState:UIControlStateNormal];
    [self.enableCameraButton setImage:[UIImage imageNamedFromBundle:@"video_gray"] forState:UIControlStateSelected];
    [self.enableCameraButton addTarget:self action:@selector(enableVideoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.enableCameraButton];
    [self.enableCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(self.microphoneButton.mas_right).offset(40);
        make.centerX.equalTo(self.view).with.multipliedBy(1.7);
        make.bottom.equalTo(self.switchCameraButton);
        make.width.height.equalTo(@(size));
    }];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError* error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions: AVAudioSessionCategoryOptionAllowBluetooth error:&error];
    if(error != nil)
        return;
    [audioSession setActive:YES error:&error];
    if(error != nil)
        return;
    [self.enableCameraButton setEnabled:NO];
    [self.switchCameraButton setEnabled:NO];
    [self.microphoneButton setEnabled:NO];
}

- (void)answerAction
{
}

- (void)hangupAction
{
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
}

- (void)switchCameraAction
{
    self.switchCameraButton.selected = !self.switchCameraButton.isSelected;
    [[EaseCallManager sharedManager] switchCameraAction];
}

- (void)speakerAction
{
    self.speakerButton.selected = !self.speakerButton.isSelected;
    if(self.speakerButton.isSelected){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError* error = nil;
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        if(error != nil)
            return;
        [audioSession setActive:YES error:&error];
        if(error != nil)
            return;
    }else{
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError* error = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions: AVAudioSessionCategoryOptionAllowBluetooth error:&error];
        if(error != nil)
            return;
        [audioSession setActive:YES error:&error];
        if(error != nil)
            return;
    }
}

- (void)muteAction
{
    self.microphoneButton.selected = !self.microphoneButton.isSelected;
    [[EaseCallManager sharedManager] muteAction:!self.microphoneButton.selected];
}

- (void)enableVideoAction
{
    self.enableCameraButton.selected = !self.enableCameraButton.isSelected;
    [[EaseCallManager sharedManager] enableVideoAction:self.enableCameraButton.selected];
}


#pragma mark - timer

- (void)startTimer
{
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont systemFontOfSize:25];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.text = @"00:00";
    [self.view addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@45);
        make.centerX.equalTo(self.view);
    }];
    _timeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int m = (_timeLength) / 60;
    int s = _timeLength - m * 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
