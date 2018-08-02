//
//  NSDate+lvfj.h
//  KuaiEx
//
//  Created by 吕飞俊 on 16/5/25.
//  Copyright © 2016年 Goudu KuaiEx Technology(Shenzhen)Co.,ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EnumDateFormatterTypeHHmmss = 0,
    EnumDateFormatterTypeyyyyMMdd,
    EnumDateFormatterTypeyyyyMMddHHmmss,
    
    EnumDateFormatterTypeHms,
    EnumDateFormatterTypeyMd,
    EnumDateFormatterTypeyMdHms,
    
    EnumDateFormatterTypeyMdE,
    
}EnumDateFormatterType;

@interface NSDate (lvfj)

+(NSDateFormatter *)getDateFormatter:(NSString *)format;
+(NSString *)getyyyyMMddDate:(NSDate *)date;
+(NSString *)threeMonthAgoyMdEDate;
/*当前时间 yyyy-MM-dd WW*/
+ (NSString *)currentyMdEDate;
/*转格式：yyyy-MM-dd WW*/
+(NSString *)getyMdEDate:(NSDate *)date;

+(NSString *)currentyyyyMMddDate;

/**日期字符串格式化：服务器返回*/
+(NSString *)getyMdHmsDateWithString:(NSString *)date;

/***/
+(BOOL)isToday:(NSString *)dateTime;
+(double)dateWithNowTime;

+(BOOL)compareString1:(NSString *)string1 string2:(NSString *)string2;
+(BOOL)isSameday:(NSDate *)date1 day2:(NSDate *)date2;
+(NSComparisonResult)compareDate1:(NSDate *)date1 day2:(NSDate *)date2;
+(NSComparisonResult)compareString:(NSString *)string date:(NSDate *)date;
+(NSDate *)getDateThreeMonthAgo;
+(NSString *)getThreeMonthAgoString;
+(NSDate *)getBeginDate;
+(NSDate *)getEndDate;

+(NSDate *)ChineseDate;
+(NSString *)ChineseDateYYMMDD;

@end
