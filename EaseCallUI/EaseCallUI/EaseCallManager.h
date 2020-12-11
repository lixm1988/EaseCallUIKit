//
//  EaseCallManager.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/18.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseCallConfig.h"
#import <Hyphenate/Hyphenate.h>

typedef NS_ENUM(NSInteger,EaseCallType) {
    EaseCallType1v1,
    EaseCallTypeMulti
};


@protocol EaseCallDelegate <NSObject>
// 结束时通话时长
- (void)singleCallDidEnd:(EMCallEndReason)reason;
- (void)multiCallDidEnd:(EMCallEndReason)reason;
- (void)multiCallDidInvitingCurVC:(UIViewController*)vc;
// 振铃时增加回调
@end

NS_ASSUME_NONNULL_BEGIN

@interface EaseCallManager : NSObject<EMChatManagerDelegate,EMConferenceManagerDelegate>
+ (instancetype)sharedManager;
- (void)initWithConfig:(EaseCallConfig*)aConfig delegate:(id<EaseCallDelegate>)aDelegate;
// 每次通话时的配置（标题、振铃文件、是否振动）,通话类型（语音、视频）
- (void)start1v1CallWithUid:(NSString*)uId completion:(void (^)(EMError*))aCompletionBlock;
- (void)inviteUsers:(NSArray<NSString*>*)aUsers  completion:(void (^)(EMError*))aCompletionBlock;
@end

NS_ASSUME_NONNULL_END
