//
//  YYStockDemoTableViewController.h
//  YYStockDemo
//
//  Created by yate1996 on 16/10/17.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lvfjBaseViewController.h"

@interface lvfjStockViewController : lvfjBaseViewController

-(instancetype)initWithName:(NSString *)name code:(NSString *)code;

@property (copy) NSString *code;
@property (strong, nonatomic) NSDictionary *dic;
@property (copy, nonatomic) NSString *timeDec;
- (void)fetchData:(NSString *)code;

@end
