//
//  ChannelModel.m
//  TestChannel
//
//  Created by fen on 16/5/4.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#import "ChannelModel.h"

@implementation ChannelModel

SGR_DEF_SINGLETION(ChannelModel);

- (instancetype)init{
    self = [super init];
    if (self) {
        self.channel = @[@{@"channelID":@"1",@"channelName":@"语文"},
                     @{@"channelID":@"2",@"channelName":@"数学"},
                     @{@"channelID":@"3",@"channelName":@"英语"},
                     @{@"channelID":@"4",@"channelName":@"历史"},
                     @{@"channelID":@"5",@"channelName":@"物理"},
                     @{@"channelID":@"6",@"channelName":@"化学"},
                     @{@"channelID":@"7",@"channelName":@"体育"},
                     @{@"channelID":@"8",@"channelName":@"美术"}];
    }
    return self;
}

-(NSDictionary *)channelAtIndex:(NSInteger)index{
    if (index<[_channel count]) {
        return (NSDictionary *)[_channel objectAtIndex:index];
    }
    return nil;
}

-(NSUInteger)indexForChannel:(NSDictionary *)channel{
    NSString *channelId = [channel objectForKey:@"channelID"];
    if (!channelId) {
        return NSNotFound;
    }
    
    for (NSUInteger i = 0; i<[_channel count]; i++) {
        NSDictionary *element = [_channel objectAtIndex:i];
        if ([[element objectForKey:@"channelID"] isEqualToString:channelId]) {
            return i;
        }
    }
    
    return NSNotFound;
}

-(NSUInteger)indexForChannelName:(NSString *)channelName{
    return [_channel indexOfObjectPassingTest:^BOOL(NSDictionary *element, NSUInteger idx, BOOL *stop){
        return [[element objectForKey:@"channelID"] isEqualToString:channelName];
    }];
}


@end
