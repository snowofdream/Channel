//
//  ControllerScrollView.m
//  TestChannel
//
//  Created by fen on 16/5/4.
//  Copyright © 2016年 testDefaultImage. All rights reserved.
//

#import "ControllerScrollView.h"
@interface ControllerScrollView() <UIScrollViewDelegate>{
CGFloat *_offsetXs;
}
@property(nonatomic,strong)NSMutableDictionary *subControllers;
@property(nonatomic,strong)NSMutableArray *placeHolderImages;

@end


@implementation ControllerScrollView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _subControllers = [NSMutableDictionary new];
        self.delegate = self;
        [self addObserver:self forKeyPath:@"contentOffset" options:0 context:@"contentOffset"];
        _placeHolderImages = [NSMutableArray new];
        for (NSUInteger i = 0; i<3; i++) {
            UIImageView *defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 90)];
            defaultImage.image = [UIImage imageNamed:@"page_loadingorloading_failure.png"];
            [self addSubview:defaultImage];
            [_placeHolderImages addObject:defaultImage];
        }
    }
    return self;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (context == @"contentOffset") {
        if (self.dragging || self.decelerating) {
            [self updateProgress];
            [self updatePlaceHolderImages];
        }
    }
    else if (context == @"selectedIndex"){
        NSUInteger oldIndex = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        if (oldIndex != _model.selectedIndex) {
            [self reloadViews];
            bool moveSoFar = _model.selectedIndex > oldIndex + 1 || oldIndex > _model.selectedIndex + 1;
            if (moveSoFar) {
                // 移动太远时直接跳转, 无移动动画
                [self.layer removeAllAnimations];
            }
        }
    }
}

-(void)updatePlaceHolderImages{
    if (!_model.channel || _model.channel.count == 0) {
        return;
    }
    
    NSUInteger index = [self indexForOffsetX:self.contentOffset.x];
    CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    if (index>0) {
        [_placeHolderImages[0] setCenter:CGPointMake(_offsetXs[index-1]+center.x, center.y)];
    }
    [_placeHolderImages[1] setCenter:CGPointMake(_offsetXs[index]+center.x, center.y)];
    [_placeHolderImages[2] setCenter:CGPointMake(_offsetXs[index+1]+center.x, center.y)];
    
}

- (void)updateProgress {
    if (_model.channel.count == 0) {
        _model.progress = _model.selectedIndex;
        return;
    }
    
    CGPoint offset = self.contentOffset;
    NSUInteger index = [self indexForOffsetX:offset.x];
    CGFloat width = _offsetXs[index+1] - _offsetXs[index];
    if (width < 10) { width = 10; }
    CGFloat extend = offset.x - _offsetXs[index];
    CGFloat progress = index + extend / width;
    
    _model.progress = progress;
}


-(NSUInteger)indexForOffsetX:(CGFloat)offsetX{
    NSUInteger count = _model.channel.count;
    NSUInteger i = 1;
    for (; i<count; i++) {
        if(_offsetXs[i]>offsetX) return i-1;
    }
    return i-1;
}

-(void)setModel:(ChannelModel *)model{
    if (_model != model) {
        if (_model) {
            [_model removeObserver:self forKeyPath:@"selectedIndex"];
        }
    }
    _model = model;
    if (_model) {
        [_model addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld context:@"selectedIndex"];
    }
    [self reloadData];
}

- (void)reloadData{
    if ([_model.channel count]>0) {
        [self allocForOffsetXs:_model.channel.count+1];
        CGFloat *offsetXs = _offsetXs;
        CGFloat offsetX = 0;
        for (id element in _model.channel) {
            *offsetXs = offsetX;
            ++offsetXs;
            offsetX += [[UIScreen mainScreen] bounds].size.width;
        }
        *offsetXs = offsetX;
        self.contentSize = CGSizeMake(offsetX, self.bounds.size.height);
        [self reloadViews];
    }
    else{
        [_subControllers removeAllObjects];
    }
}

- (void)allocForOffsetXs:(NSUInteger)channelCount{
    if (channelCount>0) {
        size_t size = channelCount * sizeof(CGFloat);
        _offsetXs = realloc(_offsetXs, size);
    }
}

-(void)scrollToIndex:(NSUInteger)index{
    self.contentOffset = CGPointMake(_offsetXs[index], 0);
}

-(void)reloadViews{
    [self layoutControllers];
    [self scrollToIndex:_model.selectedIndex];
}
- (void)layoutControllers {

    if ([_model.channel count] == 0) {
        return;
    }
    
    NSMutableDictionary *newSubDictionary = [NSMutableDictionary new];
    NSUInteger currentIndex = _model.selectedIndex;
    for (int i = -1; i<2; ++i) {
        NSUInteger index = currentIndex + i;
        if (index < _model.channel.count) {
        NSDictionary *element = _model.channel[index];
        UIViewController <ControllerScrollViewDelegate> *ctrl = [_subControllers objectForKey:[element objectForKey:@"channelID"] ];
        if (ctrl) {
            [_subControllers removeObjectForKey:[element objectForKey:@"channelID"]];
            newSubDictionary[[element objectForKey:@"channelID"]] = ctrl;
            [UIView setAnimationsEnabled:NO];
            ctrl.view.frame = [self frameAtIndex:index];
            [UIView setAnimationsEnabled:YES];
        }
        else{
            ctrl = [[self classForChannel:element] new];
            newSubDictionary[[element objectForKey:@"channelID"]] = ctrl;
            [UIView setAnimationsEnabled:NO];
            [self addSubview:ctrl.view];
            ctrl.view.frame = [self frameAtIndex:index];
            [ctrl updateControllerWithDataSource:element];
            [UIView setAnimationsEnabled:YES];

        }
        }
    }
    
    _subControllers = newSubDictionary;
    [self updateCurrentForControllers];
}

-(UIViewController *)currentController{
    id identifier = ((NSDictionary *)[_model channelAtIndex:_model.selectedIndex])[@"channelID"];
    return _subControllers[identifier];
}

-(void)updateCurrentForControllers{
    id currentCtrl = [self currentController];
    for (UIViewController <ControllerScrollViewDelegate>* ctrl in _subControllers.objectEnumerator){
        if (ctrl && [ctrl respondsToSelector:@selector(updateControllerWithIsCurrent:)]) {
            [ctrl updateControllerWithIsCurrent:currentCtrl==ctrl];
        }
    }
}

-(Class)classForChannel:(NSDictionary *)channel{
    return (NSClassFromString(@"IndexViewController"));
}

-(CGRect)frameAtIndex:(NSUInteger)index{
    return CGRectMake(_offsetXs[index], 0, _offsetXs[index+1]-_offsetXs[index], self.bounds.size.height);
}

#pragma -
#pragma UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (_model.channel.count == 0) {
        return;
    }
    
    CGPoint offset = scrollView.contentOffset;
    NSUInteger index = [self indexForOffsetX:scrollView.contentOffset.x];
    #define StayAndNearRight (fabs(velocity.x) > 0.1 && offset.x > ( _offsetXs[index+1] + _offsetXs[index]) / 2 )
    #define CanMoveToRight (index+1 < _model.channel.count)
    if (((velocity.x > 0) || CanMoveToRight) && StayAndNearRight ) {
        index = index+1;
    }
    targetContentOffset->x = _offsetXs[index];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_model.channel.count == 0) {
        return;
    }
    NSUInteger index = [self indexForOffsetX:scrollView.contentOffset.x];
    _model.selectedIndex = index;
}
@end
