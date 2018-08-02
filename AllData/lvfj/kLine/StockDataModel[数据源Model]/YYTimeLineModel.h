//
//  YYTimeLineModel.h
//  投融宝
//
//  Created by yate1996 on 16/10/10.
//  Copyright © 2016年 yeeyuntech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYStockTimeLineProtocol.h"


/**
 外部实现
 */
@interface YYTimeLineModel : NSObject <YYStockTimeLineProtocol>

#pragma mark lvfj
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat average;
@property (nonatomic, assign) NSInteger volume;
@property (nonatomic, assign) NSInteger time;

@end
