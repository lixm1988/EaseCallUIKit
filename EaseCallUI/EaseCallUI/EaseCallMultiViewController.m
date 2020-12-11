//
//  EaseCallMultiViewController.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallMultiViewController.h"
#import "EaseCallStreamView.h"
#import "EaseCallManager+Private.h"
#import "EaseCallPlaceholderView.h"
#import <Masonry/Masonry.h>
#import "UIImage+Ext.h"

@interface EaseCallMultiViewController ()
@property (nonatomic) NSMutableDictionary* streamViewsDic;
@property (nonatomic) NSMutableDictionary* placeHolderViewsDic;
@property (nonatomic) EaseCallStreamView* localView;
@property (nonatomic) UIButton* inviteButton;
@end

@implementation EaseCallMultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubViews];
    [self startTimer];
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor grayColor];
    self.inviteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.inviteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.inviteButton setImage:[UIImage imageNamedFromBundle:@"invite_white"] forState:UIControlStateNormal];
    [self.inviteButton addTarget:self action:@selector(inviteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inviteButton];
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@45);
        make.right.equalTo(self.view).offset(-40);
        make.width.height.equalTo(@30);
    }];
    [self.view bringSubviewToFront:self.inviteButton];
    [self.inviteButton setHidden:YES];
    
    if(self.localView) {
        [self.answerButton setHidden:YES];
        [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
        }];
    }
}

- (NSMutableDictionary*)streamViewsDic
{
    if(!_streamViewsDic) {
        _streamViewsDic = [NSMutableDictionary dictionary];
    }
    return _streamViewsDic;
}

- (NSMutableDictionary*)placeHolderViewsDic
{
    if(!_placeHolderViewsDic) {
        _placeHolderViewsDic = [NSMutableDictionary dictionary];
    }
    return _placeHolderViewsDic;
}

- (void)addRemoteView:(EMCallRemoteView*)remoteView streamId:(NSString*)streamId  member:(NSString*)uId
{
    EaseCallStreamView* view = [[EaseCallStreamView alloc] init];
    view.displayView = remoteView;
    [view addSubview:remoteView];
    [self.view addSubview:view];
    [remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
    }];
    [self.view sendSubviewToBack:view];
    [self.streamViewsDic setObject:view forKey:streamId];
    if([uId length] > 0)
       [self removePlaceHolderForMember:uId];
    [self updateViewPos];
}
- (void)removeRemoteViewForStreamId:(NSString*)streamId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:streamId];
    if(view) {
        [view removeFromSuperview];
        [self.streamViewsDic removeObjectForKey:streamId];
    }
    [self updateViewPos];
}
- (void)setRemoteMute:(BOOL)aMuted streamId:(NSString*)streamId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:streamId];
    if(view) {
        view.enableVoice = !aMuted;
    }
}
- (void)setRemoteEnableVideo:(BOOL)aEnabled streamId:(NSString*)streamId
{
    EaseCallStreamView* view = [self.streamViewsDic objectForKey:streamId];
    if(view) {
        view.enableVideo = aEnabled;
    }
}

- (void)setLocalVideoView:(EMCallLocalView*)aDisplayView
{
    self.localView = [[EaseCallStreamView alloc] init];
    self.localView.displayView = aDisplayView;
    [self.localView addSubview:aDisplayView];
    [aDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.localView);
    }];
    [self.view addSubview:self.localView];
    //[self.view sendSubviewToBack:self.localView];
    [self updateViewPos];
    [self.answerButton setHidden:YES];
    [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
    }];
    [self.inviteButton setHidden:NO];
    
    [self.enableCameraButton setEnabled:YES];
    [self.switchCameraButton setEnabled:YES];
    [self.microphoneButton setEnabled:YES];
    self.enableCameraButton.selected = YES;
}

- (void)updateViewPos
{
    unsigned long count = self.streamViewsDic.count + self.placeHolderViewsDic.count;
    if(self.localView.displayView)
        count++;
    int index = 0;
    int top = 80;
    int left = 10;
    int right = 10;
    int colSize = 1;
    int colomns = count>6?3:2;
    int cellwidth = (self.view.frame.size.width - left - right - (colomns - 1)*colSize)/colomns ;
    int cellHeight = cellwidth;
    if(self.localView.displayView) {
        self.localView.frame = CGRectMake(left + index%colomns * (cellwidth + colSize), top + index/colomns * (cellHeight + colSize), cellwidth, cellHeight);
        index++;
    }
    NSArray* views = [self.streamViewsDic allValues];
    for(EaseCallStreamView* view in views) {
        view.frame = CGRectMake(left + index%colomns * (cellwidth + colSize), top + index/colomns * (cellHeight + colSize), cellwidth, cellHeight);
        index++;
    }
    
    NSArray* placeViews = [self.placeHolderViewsDic allValues];
    for(EaseCallPlaceholderView* placeView in placeViews) {
        placeView.frame = CGRectMake(left + index%colomns * (cellwidth + colSize), top + index/colomns * (cellHeight + colSize), cellwidth, cellHeight);
        index++;
    }
}

- (void)inviteAction
{
    [[EaseCallManager sharedManager] inviteMemberAction];
}

- (void)answerAction
{
    [self.answerButton setHidden:YES];
    [self.hangupButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
    }];
    [[EaseCallManager sharedManager] acceptWithType:EaseCallTypeMulti];
}

- (void)hangupAction
{
    [super hangupAction];
    [[EaseCallManager sharedManager] hangupWithType:EaseCallTypeMulti];
}

- (void)muteAction
{
    [super muteAction];
    self.localView.enableVoice = self.microphoneButton.isSelected;
}

- (void)setPlaceHolderUrl:(NSURL*)url member:(NSString*)uId
{
    EaseCallPlaceholderView* placeHolderView = [[EaseCallPlaceholderView alloc] init];
    [self.view addSubview:placeHolderView];
    [placeHolderView.nameLabel setText:uId];
    NSData* data = [NSData dataWithContentsOfURL:url ];
    [placeHolderView.placeHolder setImage:[UIImage imageWithData:data]];
    [self.placeHolderViewsDic setObject:placeHolderView forKey:uId];
    [self updateViewPos];
}

- (void)removePlaceHolderForMember:(NSString*)uId
{
    EaseCallPlaceholderView* view = [self.placeHolderViewsDic objectForKey:uId];
    if(view)
       [view removeFromSuperview];
    [self.placeHolderViewsDic removeObjectForKey:uId];
    [self updateViewPos];
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
