//
//  YYLineDataModel.m
//  投融宝
//
//  Created by yate1996 on 16/10/5.
//  Copyright © 2016年 yeeyuntech. All rights reserved.
//

#import "YYLineDataModel.h"

@interface YYLineDataModel()

/**
 持有字典数组，用来计算ma值
 */
@property (nonatomic, strong) NSArray *parentDictArray;

@end

//非分时
NSString * const dayOpen      = @"Open";
NSString * const dayClose     = @"Close";
NSString * const dayLow       = @"Low";
NSString * const dayHigh      = @"High";
NSString * const dayVolume    = @"volumn";
NSString * const dayDay       = @"time";

@implementation YYLineDataModel

{
    NSDictionary * _dict;
    NSString *Close;
    NSString *Open;
    NSString *Low;
    NSString *High;
    NSString *Volume;
    NSNumber *MA5;
    NSNumber *MA10;
    NSNumber *MA20;
    
}

- (NSString *)Day {
    return self.showDay ? self.showDay: @"";
    
//    NSString *day = [_dict[@"day"] stringValue];
//    return [NSString stringWithFormat:@"%@-%@-%@",[day substringToIndex:4],[day substringWithRange:NSMakeRange(4, 2)],[day substringWithRange:NSMakeRange(6, 2)]];
//    
//    if (self.parentDictArray.count % 5 == ([self.parentDictArray indexOfObject:_dict] + 1 )%5 ) {
//        return [NSString stringWithFormat:@"%@-%@-%@",[day substringToIndex:4],[day substringWithRange:NSMakeRange(4, 2)],[day substringWithRange:NSMakeRange(6, 2)]];
//    }
//    return @"";
}

- (NSString *)DayDatail {
    NSString *day = [_dict[dayDay] stringValue];
    return [NSString stringWithFormat:@"%@-%@-%@",[day substringToIndex:4],[day substringWithRange:NSMakeRange(4, 2)],[day substringWithRange:NSMakeRange(6, 2)]];
}

- (id<YYLineDataModelProtocol>)preDataModel {
    if (_preDataModel != nil) {
        return _preDataModel;
    } else {
        return [[YYLineDataModel alloc]init];
    }
}

- (NSNumber *)Open {
//    NSLog(@"%i",[[_dict[@"day"] stringValue] hasSuffix:@"01"]);
    return _dict[dayOpen];
}

- (NSNumber *)Close {
    return _dict[dayClose];
}

- (NSNumber *)High {
    return _dict[dayHigh];
}

- (NSNumber *)Low {
    return _dict[dayLow];
}

- (CGFloat)Volume {
    return [_dict[dayVolume] floatValue]/100.f;
}

- (BOOL)isShowDay {
    return self.showDay.length > 0;
//    return [[_dict[@"day"] stringValue] hasSuffix:@"01"];
}

- (NSNumber *)MA5 {
    return MA5;
}

- (NSNumber *)MA10 {
    return MA10;
}

- (NSNumber *)MA20 {
    return MA20;
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {        
        _dict = dict;
        Close = _dict[dayClose];
        Open = _dict[dayOpen];
        High = _dict[dayHigh];
        Low = _dict[dayLow];
        Volume = _dict[dayVolume];
    }
    return self;
}

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[dayDay] = array[0];
        Open = dict[dayOpen] = array[1];
        High = dict[dayHigh] = array[2];
        Low = dict[dayLow] = array[3];
        Close = dict[dayClose] = array[4];
        Volume = dict[dayVolume] = array[5];
        _dict = dict;
    }
    return self;
}

-(NSMutableDictionary *)innerDicWithArray:(NSArray *)array{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[dayDay] = array[0];
    dict[dayOpen] = array[1];
    dict[dayHigh] = array[2];
    dict[dayLow] = array[3];
    dict[dayClose] = array[4];
    dict[dayVolume] = array[5];
    return dict;
}

- (void)updateMA:(NSArray *)array index:(NSInteger)index{
    
    NSMutableArray *mArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mArray addObject:[self innerDicWithArray:obj]];
    }];
    _parentDictArray = mArray;
    
    if (index >= 4) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-4, 5)];
        CGFloat average = [[[array valueForKeyPath:dayClose] valueForKeyPath:@"@avg.floatValue"] floatValue];
        MA5 = @(average);
    } else {
        MA5 = @0;
    }
    
    if (index >= 9) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-9, 10)];
        CGFloat average = [[[array valueForKeyPath:dayClose] valueForKeyPath:@"@avg.floatValue"] floatValue];
        MA10 = @(average);
    } else {
        MA10 = @0;
    }
    
    if (index >= 19) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-19, 20)];
        CGFloat average = [[[array valueForKeyPath:dayClose] valueForKeyPath:@"@avg.floatValue"] floatValue];
        MA20 = @(average);
    } else {
        MA20 = @0;
    }
    
}

@end
