//
//  KRTableView.m
//  KRMultipleScrollViewDemo
//
//  Created by wukerui on 2017/12/7.
//  Copyright © 2017年 kerui. All rights reserved.
//

#import "KRTableView.h"

@implementation KRTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
