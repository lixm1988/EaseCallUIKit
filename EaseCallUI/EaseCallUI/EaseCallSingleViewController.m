//
//  EaseCallSingleViewController.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallSingleViewController.h"
#import <Masonry/Masonry.h>
#import "EaseCallManager+Private.h"

@interface EaseCallSingleViewController ()<EaseCallStreamViewDelegate>
@property (nonatomic) NSString* remoteName;
@property (nonatomic) UILabel* statusLable;
@end

@implementation EaseCallSingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.remoteNameLable = [[UILabel alloc] init];
    self.remoteNameLable.backgroundColor = [UIColor clearColor];
    self.remoteNameLable.font = [UIFont systemFontOfSize:28];
    self.remoteNameLable.textColor = [UIColor blackColor];
    self.remoteNameLable.textAlignment = NSTextAlignmentRight;
    self.remoteNameLable.text = self.remoteName;
    [self.timeLabel setHidden:YES];
    [self.view addSubview:self.remoteNameLable];
    [self.remoteNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@45);
        make.centerX.equalTo(self.view);
    }];
    self.statusLable = [[UILabel alloc] init];
    self.statusLable.backgroundColor = [UIColor clearColor];
    self.statusLable.font = [UIFont systemFontOfSize:24];
    self.statusLable.textColor = [UIColor blackColor];
    self.statusLable.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.statusLable];
    [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remoteNameLable.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
    if(self.isCaller) {
        self.statusLable.text = @"正在等待对方接听...";
        [self.answerButton setHidden:YES];
        [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
        }];
    }else
        self.statusLable.text = @"收到对方视频通话请求";
}

- (nonnull instancetype)initWithisCaller:(BOOL)aIsCaller remoteName:(NSString*)aRemoteName { 
    self = [super init];
    if(self) {
        self.isCaller = aIsCaller;
        self.remoteName = aRemoteName;
    }
    return  self;
}

- (void)setLocalView:(EaseCallStreamView *)localView
{
    _localView = localView;
    [self.view addSubview:_localView];
    [self.view sendSubviewToBack:_localView];
    localView.delegate = self;
    [_localView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.enableCameraButton setEnabled:YES];
    [self.switchCameraButton setEnabled:YES];
    [self.microphoneButton setEnabled:YES];
    self.enableCameraButton.selected = YES;
}

- (void)setRemoteView:(EaseCallStreamView *)remoteView
{
    _remoteView = remoteView;
    remoteView.delegate = self;
    [self.view addSubview:_remoteView];
    [_remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@100);
        make.right.equalTo(self.view).with.offset(-40);
        make.top.equalTo(self.view).with.offset(70);
    }];
    [self startTimer];
    [self.remoteNameLable setHidden:YES];
    [self.statusLable setHidden:YES];
}

- (void)answerAction
{
    [self.answerButton setHidden:YES];
    [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
    }];
    [[EaseCallManager sharedManager] acceptWithType:EaseCallType1v1];
}

- (void)hangupAction
{
    [super hangupAction];
    [[EaseCallManager sharedManager] hangupWithType:EaseCallType1v1];
}

- (void)muteAction
{
    [super muteAction];
    self.localView.enableVoice = self.microphoneButton.isSelected;
}

- (void)streamViewDidTap:(EaseCallStreamView *)aVideoView
{
    if(aVideoView.frame.size.width == 80) {
        [self.view sendSubviewToBack:aVideoView];
        EaseCallStreamView *otherView = aVideoView == self.localView?self.remoteView:self.localView;
        [otherView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.height.equalTo(@100);
            make.right.equalTo(self.view).with.offset(-40);
            make.top.equalTo(self.view).with.offset(70);
        }];
        [aVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
    }
}

- (void)setLocalDisplayView:(UIView*)aDisplayView
{
    if(self.localView)
    {
        self.localView.displayView = aDisplayView;
        self.localView.delegate = self;
        [self.localView addSubview:aDisplayView];
        [aDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.localView);
        }];
    }
}
- (void)setRemoteDisplayView:(UIView*)aDisplayView
{
    if(self.remoteView)
    {
        self.remoteView.displayView = aDisplayView;
        self.remoteView.delegate = self;
        [self.remoteView addSubview:aDisplayView];
        [aDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.remoteView);
        }];
    }
}


@end
