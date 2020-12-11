//
//  EaseCallConfig.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/12/9.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallConfig.h"

@implementation EaseCallConfig
- (instancetype)init
{
    self = [super init];
    if(self) {
        [self _initParams];
    }
    return self;
}

- (void)_initParams
{
    _callTimeOut = 30;
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"watermark" ofType:@"png"];
    _placeHolderURL = [NSURL fileURLWithPath:imagePath];
}

- (void)setPlaceHolderURL:(NSURL *)placeHolderURL
{
    if(placeHolderURL)
        _placeHolderURL = placeHolderURL;
}
@end
