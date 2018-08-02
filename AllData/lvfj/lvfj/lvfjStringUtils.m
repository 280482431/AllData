//
//  StringUtils.m
//  JQBV2
//
//  Created by dev on 14-8-22.
//  Copyright (c) 2014年 EFunds. All rights reserved.
//

#import "lvfjStringUtils.h"

@implementation lvfjStringUtils

#pragma mark nil

+ (BOOL)isEmptyString:(id)string{
    return string==nil || string==[NSNull null] || ![string isKindOfClass:[NSString class]] || [(NSString *)string length]==0 || [(NSString *)string isEqualToString:@"(null)"];
}

+(NSString *)emptyStringReplaceNSNull:(id)string{
    if ([self isEmptyString:string]) {
        return @"";
    }else{
        return string;
    }
}

+(NSString *)emptyStringReplaceZero:(id)string{
    if ([self isEmptyString:string]) {
        return @"0";
    }else{
        return string;
    }
}

+(BOOL)isHasString:(id)string{
    BOOL result = ![lvfjStringUtils isEmptyString:string];
    if (result) {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
        result = trimmedString.length>0;
    }
    return result;
}

+ (BOOL)isValidateMobileNumber:(NSString *)text
{
    return [lvfjStringUtils isSubmitRegex:@"^1\\d{10}$" text:text];
}

/**数字和字母*/
+(BOOL)isCharacterNo:(NSString *)text{
    return [lvfjStringUtils isSubmitRegex:@"^(\\w){1,}$" text:text];
}

+(BOOL)isValidateSecret:(NSString *)text{
     return [lvfjStringUtils isCharacterNo:text];
}

/**数字*/
+(BOOL)isNo:(NSString *)text{
    return [lvfjStringUtils isSubmitRegex:@"^(\\d)*$" text:text];
}

/**小数格式*/
+(BOOL)isDecimalNo:(NSString *)text{
    return [lvfjStringUtils isSubmitRegex:@"^(\\d)*$|^((\\d)+(\\.)(\\d){0,})$" text:text];
}
//return [lvfjStringUtils isSubmitRegex:@"^(\\d)*$|^((\\d)+(\\.)(\\d){0,3})$" text:text];

/**是否符合*/
+(BOOL)isSubmitRegex:(NSString *)regex text:(NSString *)text{
    NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [prd evaluateWithObject:text];
}

+(NSString *)zeroReplayEmptyString:(id)string
{
    if ([self isEmptyString:string]) {
        return @"0";
    }else{
        return string;
    }
}

+(NSString *)getString:(id)string{
    return [NSString stringWithFormat:@"%@",string];
}

@end
