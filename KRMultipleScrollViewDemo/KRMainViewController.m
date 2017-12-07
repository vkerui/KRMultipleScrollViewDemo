//
//  KRMainViewController.m
//  KRMultipleScrollViewDemo
//
//  Created by wukerui on 2017/12/7.
//  Copyright © 2017年 kerui. All rights reserved.
//

#import "KRMainViewController.h"
#import "KRSubViewController.h"
#import "KRSubScrollViewScrollDelegate.h"

#define HEADER_VIEW_HEIGHT 200
#define MIDDLE_VIEW_HEIGHT 44
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface KRMainViewController ()<UIScrollViewDelegate, KRSubScrollViewScrollDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *subScrollView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) NSArray<KRSubViewController *> *subViewControllers;

@end

@implementation KRMainViewController
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (UIScrollView *)subScrollView {
    if (!_subScrollView) {
        _subScrollView = [[UIScrollView alloc] init];
        _subScrollView.delegate = self;
        _subScrollView.showsHorizontalScrollIndicator = NO;
        _subScrollView.pagingEnabled = YES;
    }
    return _subScrollView;
}

- (NSArray<KRSubViewController *> *)subViewControllers {
    if (!_subViewControllers) {
        NSMutableArray *subViewControllers = [NSMutableArray array];
        KRSubViewController *vc1 = [[KRSubViewController alloc] init];
        vc1.delegate = self;
        vc1.tableView.canScroll = YES;
        KRSubViewController *vc2 = [[KRSubViewController alloc] init];
        vc2.delegate = self;
        vc2.tableView.canScroll = YES;
        KRSubViewController *vc3 = [[KRSubViewController alloc] init];
        vc3.delegate = self;
        vc3.tableView.canScroll = YES;
        
        [subViewControllers addObject:vc1];
        [subViewControllers addObject:vc2];
        [subViewControllers addObject:vc3];
        
        _subViewControllers = subViewControllers;
    }
    return _subViewControllers;
}


- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}

- (UIView *)middleView {
    if (!_middleView) {
        _middleView = [[UIView alloc] init];
        _middleView.backgroundColor = [UIColor grayColor];
    }
    return _middleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headerView];
    [self.mainScrollView addSubview:self.middleView];
    [self.mainScrollView addSubview:self.subScrollView];
    
    for (int idx = 0; idx < self.subViewControllers.count; idx++) {
        [self.subScrollView addSubview:self.subViewControllers[idx].view];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.mainScrollView.frame = self.view.bounds;
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEADER_VIEW_HEIGHT);
    self.middleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), SCREEN_WIDTH, MIDDLE_VIEW_HEIGHT);
    self.subScrollView.frame = CGRectMake(0, HEADER_VIEW_HEIGHT + MIDDLE_VIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - MIDDLE_VIEW_HEIGHT);
    for (int idx = 0; idx < self.subViewControllers.count; idx++) {
        self.subViewControllers[idx].view.frame = CGRectMake(idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, CGRectGetHeight(self.subScrollView.frame));
    }
    
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + HEADER_VIEW_HEIGHT);
    self.subScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.subViewControllers.count, CGRectGetHeight(self.subScrollView.frame));

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainScrollView) {
        BOOL canScroll = [self getCanScroll];
        if (!canScroll) {
            [scrollView setContentOffset:CGPointMake(0, HEADER_VIEW_HEIGHT)];
        }
    } else if (scrollView ==  self.subScrollView) {
        for (int idx = 0; idx < self.subViewControllers.count; idx++) {
            self.subViewControllers[idx].tableView.scrollEnabled = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView ==  self.subScrollView) {
        for (int idx = 0; idx < self.subViewControllers.count; idx++) {
            self.subViewControllers[idx].tableView.scrollEnabled = YES;
        }

    }
}

#pragma mark - KRSubScrollViewScrollDelegate
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL canScroll = [self getCanScroll];
    if (scrollView.contentOffset.y<=0) {
        //下拉tableView的时候scrollView.contentOffset.y<=0说明子视图的滚动已经到顶部了，mainScrollView开始滚动
        [self setCanScroll:YES];
        [scrollView setContentOffset:CGPointZero];
        for (int idx = 0; idx < self.subViewControllers.count; idx++) {
            [self.subViewControllers[idx].tableView setContentOffset:CGPointZero];
            self.subViewControllers[idx].tableView.canScroll = YES;
        }
        
    }else{
        CGRect rec = [self.headerView convertRect:self.headerView.bounds toView:self.view];
        if (canScroll && CGRectGetMaxY(rec) > 0) {
            //mainScrollView没有到顶的时候，设置tableView的contentOffset为CGPointZero
            [scrollView setContentOffset:CGPointZero];
            [self setCanScroll:YES];
        }else {
            //headerView到顶部设置mainScrollView不再滚动
            [self setCanScroll:NO];
        }
    }

}

- (BOOL)getCanScroll {
    NSUInteger index = self.subScrollView.contentOffset.x / SCREEN_WIDTH;
    return self.subViewControllers[index].tableView.canScroll;
}

- (void)setCanScroll:(BOOL)canScroll {
    NSUInteger index = self.subScrollView.contentOffset.x / SCREEN_WIDTH;
    self.subViewControllers[index].tableView.canScroll = canScroll;
}

@end
