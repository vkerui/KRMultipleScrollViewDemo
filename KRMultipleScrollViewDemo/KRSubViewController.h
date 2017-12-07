//
//  KRSubViewController.h
//  KRMultipleScrollViewDemo
//
//  Created by wukerui on 2017/12/7.
//  Copyright © 2017年 kerui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRSubScrollViewScrollDelegate.h"
#import "KRTableView.h"

@interface KRSubViewController : UIViewController

@property (nonatomic, weak) id<KRSubScrollViewScrollDelegate> delegate;
@property (nonatomic, strong) KRTableView *tableView;

@end
