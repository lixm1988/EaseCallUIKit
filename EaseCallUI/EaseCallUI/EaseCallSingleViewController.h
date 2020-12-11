//
//  EaseCallSingleViewController.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/19.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallBaseViewController.h"
#import "EaseCallStreamView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseCallSingleViewController : EaseCallBaseViewController
@property (nonatomic,strong) EaseCallStreamView* remoteView;
@property (nonatomic,strong) EaseCallStreamView* localView;
@property (nonatomic) BOOL isCaller;
@property (nonatomic,strong) UILabel* remoteNameLable;

- (instancetype)initWithisCaller:(BOOL)aIsCaller  remoteName:(NSString*)aRemoteName;
- (void)setRemoteMute:(BOOL)aMuted;
- (void)setRemoteEnableVideo:(BOOL)aMuted;
- (void)setLocalDisplayView:(UIView*)aDisplayView;
- (void)setRemoteDisplayView:(UIView*)aDisplayView;
@end

NS_ASSUME_NONNULL_END
