//
//  EaseCallPlaceholderView.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/12/9.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallPlaceholderView.h"
#import <Masonry/Masonry.h>

@implementation EaseCallPlaceholderView

- (instancetype)init
{
    self = [super init];
    if(self) {
        self.backgroundColor = [UIColor blackColor];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        [self bringSubviewToFront:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-5);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(@30);
        }];
        
        self.placeHolder = [[UIImageView alloc] init];
        [self addSubview:self.placeHolder];
        [self.placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@80);
            make.center.equalTo(self);
        }];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
