//
//  IndexViewController.m
//  TestChannel
//
//  Created by fen on 16/5/4.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()
@property(nonatomic,strong) UILabel *textLab;
@property(nonatomic,strong) UILabel *currentLab;

@property(nonatomic) BOOL isCurrent;
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    _textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.font = [UIFont boldSystemFontOfSize:40];
    _textLab.textColor = [UIColor redColor];
    _textLab.center = self.view.center;
    [self.view addSubview:_textLab];
    
    _currentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _currentLab.textAlignment = NSTextAlignmentCenter;
    _currentLab.font = [UIFont boldSystemFontOfSize:40];
    _currentLab.textColor = [UIColor blackColor];
    _currentLab.center = CGPointMake(self.view.center.x, 100);
    [self.view addSubview:_currentLab];

    // Do any additional setup after loading the view.
}

-(void)updateTextLab:(NSDictionary *)dic{
    _textLab.text = [dic objectForKey:@"channelName"];
}


#pragma -
#pragma  ControllerScrollViewDelegate
-(void)updateControllerWithDataSource:(NSDictionary *)dataSource{
    [self updateTextLab:dataSource];
    _currentLab.text = self.isCurrent?@"当前":@"不当前";
}



-(void)updateControllerWithIsCurrent:(BOOL)isCurrent{
    self.isCurrent = isCurrent;
    _currentLab.text = self.isCurrent?@"当前":@"不当前";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
