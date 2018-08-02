//
//  YYTimeLineModel.m
//  投融宝
//
//  Created by yate1996 on 16/10/10.
//  Copyright © 2016年 yeeyuntech. All rights reserved.
//

#import "YYTimeLineModel.h"
#import <CoreGraphics/CoreGraphics.h>
#import "NSDate+lvfj.h"

//分时

NSString * const minuteVolume    = @"volumn";
NSString * const minutePrice     = @"price";
NSString * const minuteAvgPrice  = @"Avg";
NSString * const minuteTime      = @"time";

@implementation YYTimeLineModel
{
    NSDictionary * _dict;
    NSString *Price;
    NSString *AvgPrice;
    NSString *TimeDesc;
    NSString *Volume;
}

- (NSString *)TimeDesc {
//    NSLog(@"%d",time);
//    if( time == 780) {
//        return @"11:30/13:00";
//    } else if( time == 1020) {
//        return @"15:00";
//    } else {
//        return [NSString stringWithFormat:@"%02d:%02d",date/60,date%60];
//    }
    NSString *time = [NSString stringWithFormat:@"%@",_dict[minuteTime]];
    if (time.length==5) {
        time =  [NSString stringWithFormat:@"0%@",time];
    }
    return [NSDate getyMdHmsDateWithString:time];
}

- (NSString *)DayDatail {
    return [self TimeDesc];
//    NSInteger time = [_dict[minuteTime] integerValue];
//    return [NSString stringWithFormat:@"%02d:%02d",time/60,time%60];
}

//前一天的收盘价
- (CGFloat )AvgPrice {
    return [_dict[minutePrice] floatValue];
}

- (NSNumber *)Price {
    return _dict[minutePrice];
}

- (CGFloat)Volume {
//    return [_dict[minuteVolume] floatValue]/100.f;
    return [_dict[minuteVolume] floatValue];
}

- (BOOL)isShowTimeDesc {
    //9:30-11:30,13:00-15:00
    //11:30和13:00挨在一起，显示一个就够了
    //最后一个服务器返回的minute不是960,故只能特殊处理
    NSInteger time = [_dict[minuteTime] integerValue];
    return time == 570 ||  time == 780 ||  time == 240;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
        AvgPrice  = Price = _dict[minutePrice];
        Volume = _dict[minuteVolume];
        TimeDesc = _dict[minuteTime];
    }
    return self;
}

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        Price = dict[minutePrice] = [NSString stringWithFormat:@"%@",array[1]];
        AvgPrice = dict[minuteAvgPrice] = [NSString stringWithFormat:@"%@",array[2]];
        Volume = dict[minuteVolume] = [NSString stringWithFormat:@"%@", array[3]];
        TimeDesc= dict[minuteTime] = [NSString stringWithFormat:@"%@",array[4]];
        _dict = dict;
        
        #pragma mark lvfj
        _index = [array[0] integerValue];
        _average = [array[1] floatValue];
        _price = [array[2] floatValue];
        _volume= [array[3] integerValue];
        _time = [array[4] integerValue];
    }
    return self;
}

-(NSString *)description{
//    NSMutableString *str = [NSMutableString string];
//    _dict
    return _dict;
}

@end
