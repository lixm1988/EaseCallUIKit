//
//  EaseCallConfig.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/12/9.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 增加铃声、标题文本、环信ID与昵称的映射
@interface EaseCallConfig : NSObject
@property (nonatomic) UInt32 callTimeOut;
@property (nonatomic) NSURL* placeHolderURL;
@end

NS_ASSUME_NONNULL_END
