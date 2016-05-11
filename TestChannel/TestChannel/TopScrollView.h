//
//  TopScrollView.h
//  TestChannel
//
//  Created by fen on 16/5/10.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"
@interface TopScrollView : UIScrollView
@property(nonatomic,strong) ChannelModel *model;
@property(nonatomic,strong) NSMutableArray *buttonsArray;
@end
