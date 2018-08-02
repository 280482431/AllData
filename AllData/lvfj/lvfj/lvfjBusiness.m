//
//  lvfjBusiness.m
//  AllData
//
//  Created by lvfeijun on 2018/5/21.
//  Copyright © 2018年 lvfeijun. All rights reserved.
//

#import "lvfjBusiness.h"
#import "lvfjStringUtils.h"

@implementation lvfjBusiness

+(NSString *)toChangeNumber:(NSString *)nb{
    NSString *result = [lvfjBusiness scienceCount:nb];
    if ([lvfjStringUtils isDecimalNo:result]&&![lvfjStringUtils isEmptyString:nb]) {
        NSString *number = [[result componentsSeparatedByString:@"."]firstObject];
        if (number.length>9) {
            result = [NSString stringWithFormat:@"%.2fB",[number floatValue]/1000000000];
        }else if (number.length>6) {
            result = [NSString stringWithFormat:@"%.2fM",[number floatValue]/1000000];
        }else if (number.length>3) {
            result = [NSString stringWithFormat:@"%.2fK",[number floatValue]/1000];
        }
    }
    return result;
}

+(NSString *)scienceCount:(NSString *)nb{
    NSString *result = nb;
    NSString *temp = [lvfjStringUtils getString:nb];
    if ([temp containsString:@"E+"]) {
        NSRange eSite = [temp rangeOfString:@"E+"];
        double fund = [[temp substringWithRange:NSMakeRange(0, eSite.location)] doubleValue];  //把E前面的数截取下来当底数
        double top = [[temp substringFromIndex:eSite.location + 1] doubleValue];   //把E后面的数截取下来当指数
        double r = fund * pow(10.0, top);
        result = [NSString stringWithFormat:@"%.3f",r];
    }
    return result;
}


+(NSArray *)changeChineseNumber:(CGFloat)number{
    CGFloat changeCount = 10000.f;
    CGFloat wVolume = number/changeCount;
    NSArray *array = @[[NSString stringWithFormat:@"%.0f",number],@""];
    
    if (wVolume > 1) {
        //尝试转为亿手
        CGFloat yVolume = wVolume/changeCount;
        if (yVolume > 1) {
            array = @[[NSString stringWithFormat:@"%.2f",yVolume],@"亿"];
        }
        else{
            array = @[[NSString stringWithFormat:@"%.2f",wVolume],@"万"];
        }
    }
    return array;
}

@end
