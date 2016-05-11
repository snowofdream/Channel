//
//  ViewController.m
//  TestChannel
//
//  Created by fen on 16/5/4.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#import "ViewController.h"
#import "ControllerScrollView.h"
#import "TopScrollView.h"

@interface ViewController ()
@property(nonatomic, strong) ControllerScrollView *controllerScrollView;
@property(nonatomic, strong) TopScrollView *topScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topScrollView = [[TopScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44.f)];
    _topScrollView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _topScrollView.model = [ChannelModel sharedInstance];
    [self.view addSubview:_topScrollView];
    
    _controllerScrollView = [[ControllerScrollView alloc] initWithFrame:CGRectMake(0, 64.f, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    _controllerScrollView.model = [ChannelModel sharedInstance];
    [self.view addSubview:_controllerScrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
