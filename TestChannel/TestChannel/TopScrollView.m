//
//  TopScrollView.m
//  TestChannel
//
//  Created by fen on 16/5/10.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#import "TopScrollView.h"
@interface TopScrollView ()
@property(nonatomic) CGFloat progress;

@end

@implementation TopScrollView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonsArray = [NSMutableArray new];
    }
    return self;
}

-(void)setModel:(ChannelModel *)model{
    if (_model != model) {
        if (_model) {
            [_model removeObserver:self forKeyPath:@"selectedIndex"];
            [_model removeObserver:self forKeyPath:@"progress" context:@"progress"];

        }
    }
    _model = model;
    if (_model) {
        [_model addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld context:@"selectedIndex"];
        [_model addObserver:self forKeyPath:@"progress" options:0 context:@"progress"];
    }
    [self reloadData];
}

-(void)reloadData{
    for (UIView *btn in self.subviews) {
        [btn removeFromSuperview];
    }
    [_buttonsArray removeAllObjects];
    
    [self createButtons];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (context == @"selectedIndex"){
        [self selectAtIndex:_model.selectedIndex];
    }
    else if (context == @"progress"){
        self.progress = _model.progress;
    }
}

-(void)setProgress:(CGFloat)progress{
    if (_buttonsArray.count == 0) {
        return;
    }
    
    if (_progress != progress) {
        NSUInteger floorIndex;
        NSUInteger ceilIndex;
        
        UIButton *btn;
        UIColor *selectedColor = [UIColor redColor];
        UIColor *nomalColor = [UIColor blackColor];
        
#define ResetBtnColor(index)\
        if (index<_buttonsArray.count) {\
            btn = _buttonsArray[index];\
            [btn setTitleColor:nomalColor forState:UIControlStateNormal];\
        }
        
        floorIndex = floor(_progress);
        ceilIndex = floorIndex + 1;
        ResetBtnColor(floorIndex);
        ResetBtnColor(ceilIndex);
        
        // interpolate new Colors
        floorIndex= floor(progress);
       // ceilIndex = floorIndex + 1;
        UIButton *floorBtn = _buttonsArray[floorIndex];
        [floorBtn setTitleColor:selectedColor forState:UIControlStateNormal];
        
        _progress = progress;
    }
    
}

-(void)createButtons{
    NSArray *channels = _model.channel;
    for (NSUInteger i=0; i<channels.count; i++) {
        NSDictionary *channel = channels[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTag:100+i];
        [btn setTitle:channel[@"channelName"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(-2.5, 0, 0, 20)];
        CGSize size = [btn sizeThatFits:CGSizeMake(MAXFLOAT, 30)];
        btn.frame = (CGRect){{((UIButton *)([_buttonsArray lastObject])).frame.origin.x+((UIButton *)([_buttonsArray lastObject])).frame.size.width,11},size};
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [_buttonsArray addObject:btn];
    }
    UIButton *lastBtn = [_buttonsArray lastObject];
    self.contentSize = CGSizeMake(lastBtn.frame.origin.x+lastBtn.frame.size.width, self.frame.size.height);
    
    NSUInteger selectIndex = _model.selectedIndex;
    if (selectIndex<_model.channel.count) {
        [self selectAtIndex:selectIndex];
    }
}

-(void)selectAtIndex:(NSUInteger)index{
    if (index>=_model.channel.count) {
        return;
    }
    
    CATransition* transition = [CATransition animation];
    for (UIButton* element in _buttonsArray){
        [element.layer addAnimation:transition forKey:@"foregroundColor"];
    }
    
    self.progress = index;
    
    UIButton *selectBtn = (UIButton *)_buttonsArray[index];
    [selectBtn setTitleColor:[UIColor redColor]  forState:UIControlStateNormal];
    [self scrollRectToVisible:selectBtn.frame animated:YES];
}

-(void)selectBtn:(UIButton *)sender{
    NSUInteger index = sender.tag-100;

    _model.selectedIndex = index;
}
@end
