//
//  NSDate+lvfj.m
//  KuaiEx
//
//  Created by 吕飞俊 on 16/5/25.
//  Copyright © 2016年 Goudu KuaiEx Technology(Shenzhen)Co.,ltd. All rights reserved.
//

#import "NSDate+lvfj.h"
#import "lvfjStringUtils.h"

@implementation NSDate (lvfj)

#pragma mark dateFormatter

+(NSDateFormatter *)getDateFormatter:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}

+(NSDateFormatter *)getDateFormatterType:(EnumDateFormatterType)type{
    NSString *format=@"";
    switch (type) {
        case EnumDateFormatterTypeHHmmss:
            format = @"HHmmss";
            break;
            
        case EnumDateFormatterTypeyyyyMMdd:
            format = @"yyyyMMdd";
            break;
            
        case EnumDateFormatterTypeyyyyMMddHHmmss:
            format = @"yyyyMMddHHmmss";
            break;
            
        case EnumDateFormatterTypeHms:
            format = @"HH:mm:ss";
            break;
            
        case EnumDateFormatterTypeyMd:
            format = @"yyyy-MM-dd";
            break;
            
        case EnumDateFormatterTypeyMdHms:
            format = @"yyyy-MM-dd HH:mm:ss";
            break;
            
        case EnumDateFormatterTypeyMdE:
            format = @"yyyy-MM-dd EEEE";
            break;
            
        default:
            break;
    }
    return [NSDate getDateFormatter:format];
}


+(NSString *)getStringWithDate:(NSDate *)date dateFormatterType:(EnumDateFormatterType)type{
    NSDateFormatter *dateFormatter = [NSDate getDateFormatterType:type];
    return [dateFormatter stringFromDate:date];
}

+(NSString *)getStringDate:(NSDate *)date type:(EnumDateFormatterType)type{
    return [[NSDate getDateFormatterType:type] stringFromDate:date];
}

#pragma mark yyyyMMdd

+(NSString *)getyyyyMMddDate:(NSDate *)date{
    return [NSDate getStringDate:date type:EnumDateFormatterTypeyyyyMMdd];
}

+(NSString *)currentyyyyMMddDate{
    return [NSDate getyyyyMMddDate:[NSDate ChineseDate]];
}

#pragma mark yyyyMMddHHmmss

+(NSString *)getyyyyMMddHHmmssDate:(NSDate *)date{
    return [NSDate getStringDate:date type:EnumDateFormatterTypeyyyyMMddHHmmss];
}

#pragma mark yyyy-MM-dd EEEE

+(NSString *)getyMdEDate:(NSDate *)date{
    return [NSDate getStringDate:date type:EnumDateFormatterTypeyMdE];
}

+(NSString *)currentyMdEDate{
    return [NSDate getyMdEDate:[NSDate date]];
}

+(NSString *)threeMonthAgoyMdEDate{
    return [NSDate getyMdEDate:[NSDate setMonth:-3 day:0 hour:0 date:[NSDate date]]];
}

#pragma mark yyyy-MM-DD HH:mm:ss
+(NSString *)getyMdHmsDate:(NSDate *)date{
    return  [NSDate getStringDate:date type:EnumDateFormatterTypeyMdHms];
}

+(NSString *)getyMdHmsDateWithString:(NSString *)date{
    NSString *result = date;
    if (date.length > 5) {
        EnumDateFormatterType stringType = EnumDateFormatterTypeHHmmss;
        EnumDateFormatterType formatType = EnumDateFormatterTypeHms;
        NSInteger toIndex = 6;
        if (date.length>13) {
            stringType = EnumDateFormatterTypeyyyyMMddHHmmss;
            formatType = EnumDateFormatterTypeyMdHms;
            toIndex = 14;
        }
        else if (date.length>7){
            stringType = EnumDateFormatterTypeyyyyMMdd;
            formatType = EnumDateFormatterTypeyMd;
            toIndex = 8;
        }
        NSDateFormatter *stringFormatter = [NSDate getDateFormatterType:stringType];
        NSDate *d = [stringFormatter dateFromString:[date substringToIndex:toIndex]];
        NSDateFormatter *dateFormatter = [NSDate getDateFormatterType:formatType];
        result = [dateFormatter stringFromDate:d];
    }
    return result;
}

#pragma mark compare
+(NSComparisonResult)compareString:(NSString *)string date:(NSDate *)date{
    NSString *day = [NSDate getyyyyMMddDate:date];
    return [day compare:[string substringToIndex:8]];
}

//14
+(BOOL)compareString1:(NSString *)string1 string2:(NSString *)string2{
    NSDateFormatter *stringFormatter = [NSDate getDateFormatterType:EnumDateFormatterTypeyyyyMMddHHmmss];
    NSDate *day1 = [stringFormatter dateFromString:[string1 substringToIndex:14]];
    NSDate *day2 = [stringFormatter dateFromString:[string2 substringToIndex:14]];
    return [day1 compare:day2]==NSOrderedDescending;
}

+(BOOL)isToday:(NSString *)dateTime{
    BOOL result = NO;
    NSString *day = [lvfjStringUtils getString:dateTime];
    if (day.length>7) {
        NSString *date = [day substringToIndex:8];
        NSDateFormatter *formatter = [NSDate getDateFormatterType:EnumDateFormatterTypeyyyyMMdd];
        NSString *now = [formatter stringFromDate:[NSDate date]];
        result = [now isEqualToString:date];
    }
    return result;
}

+(BOOL)isSameday:(NSDate *)date1 day2:(NSDate *)date2 {
    NSDateFormatter *formatter = [NSDate getDateFormatterType:EnumDateFormatterTypeyyyyMMdd];
    NSString *d1 = [formatter stringFromDate:date1];
    NSString *d2 = [formatter stringFromDate:date2];
    return [d1 isEqualToString:d2];
}

+(NSComparisonResult)compareDate1:(NSDate *)date1 day2:(NSDate *)date2{
    NSComparisonResult result;
    if ([NSDate isSameday:date1 day2:date2]) {
        result = NSOrderedSame;
    }
    else{
        result = [date1 compare:date2];
    }
    return result;
}

#pragma mark setDateComponents

+(NSDate *)setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour date:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:month];
    [dateComponents setHour:hour];
    [dateComponents setDay:day];
    return [NSDate setDateComponents:dateComponents date:date];
}

+(NSDate *)setDateComponents:(NSDateComponents *)dateComponents date:(NSDate *)date{
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateByAddingComponents:dateComponents toDate:date options:0];
}

#pragma mark static date

+(NSDate *)getBeginDate{
    return [NSDate setMonth:0 day:-5 hour:0 date:[NSDate date]];
}

+(NSDate *)getEndDate{
    return [NSDate setMonth:0 day:-1 hour:0 date:[NSDate date]];
}

+(NSDate *)getDateThreeMonthAgo{
    return [NSDate setMonth:-3 day:0 hour:0 date:[NSDate ChineseDate]];
}

+(NSString *)getThreeMonthAgoString{
    return   [NSDate getyyyyMMddDate:[NSDate getDateThreeMonthAgo]];}

+(NSDate *)ChineseDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date  dateByAddingTimeInterval: interval];
//    return [zone data];
}

+(double)dateWithNowTime{
    NSDateFormatter *formatter = [NSDate getDateFormatter:@"HHmmss"];
    return [[formatter stringFromDate:[NSDate date]]doubleValue];
}

+(NSString *)ChineseDateYYMMDD{
    NSDateFormatter *formatter = [NSDate getDateFormatterType:EnumDateFormatterTypeyyyyMMdd];
    return  [formatter stringFromDate:[NSDate ChineseDate]];
}

@end
