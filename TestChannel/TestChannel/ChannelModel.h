//
//  ChannelModel.h
//  TestChannel
//
//  Created by fen on 16/5/4.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Header.h"
@interface ChannelModel : NSObject
SGR_SINGLETION(ChannelModel);

@property(nonatomic,strong)NSArray *channel;
@property (nonatomic) CGFloat progress; ///< 类似 selectedIndex, 用小数表示滑动的中间状态
@property(nonatomic) NSUInteger selectedIndex;
-(NSDictionary *)channelAtIndex:(NSInteger)index;
@end
