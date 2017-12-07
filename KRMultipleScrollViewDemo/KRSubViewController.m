//
//  KRSubViewController.m
//  KRMultipleScrollViewDemo
//
//  Created by wukerui on 2017/12/7.
//  Copyright © 2017年 kerui. All rights reserved.
//

#import "KRSubViewController.h"

@interface KRSubViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation KRSubViewController
- (KRTableView *)tableView {
    if (!_tableView) {
        _tableView = [[KRTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(subScrollViewDidScroll:)]) {
        [self.delegate subScrollViewDidScroll:scrollView];
    }
}


@end
