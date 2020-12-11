//
//  EaseCallBaseViewController.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Hyphenate/Hyphenate.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseCallBaseViewController : UIViewController
@property (nonatomic,strong) UIButton* microphoneButton;
@property (nonatomic,strong) UIButton* enableCameraButton;
@property (nonatomic,strong) UIButton* switchCameraButton;
@property (nonatomic,strong) UIButton* speakerButton;
@property (nonatomic,strong) UIButton* hangupButton;
@property (nonatomic,strong) UIButton* answerButton;
@property (nonatomic,strong) UILabel* timeLabel;
@property (strong, nonatomic) NSTimer *timeTimer;

- (void)hangupAction;
- (void)muteAction;
- (void)startTimer;
@end

NS_ASSUME_NONNULL_END
