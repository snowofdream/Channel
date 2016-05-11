//
//  ControllerScrollView.h
//  TestChannel
//
//  Created by fen on 16/5/4.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"

@protocol ControllerScrollViewDelegate <NSObject>

@required
-(void)updateControllerWithDataSource:(NSDictionary *)dataSource;

@optional

-(void)updateControllerWithIsCurrent:(BOOL)isCurrent;
@end


@interface ControllerScrollView : UIScrollView
@property(nonatomic,strong) ChannelModel *model;
@property(nonatomic,strong) NSMutableArray *child;

- (void)reloadData;
//- (UIViewController <ControllerScrollViewDelegate> *) currentViewController;

@end
