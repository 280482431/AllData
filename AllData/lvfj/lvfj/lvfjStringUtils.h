//
//  StringUtils.h
//  JQBV2
//
//  Created by 吕飞俊 on 14-8-22.
//  Copyright (c) 2014年 EFunds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface lvfjStringUtils : NSObject

+ (BOOL)isEmptyString:(id)string;

+(NSString *)emptyStringReplaceNSNull:(id)string;
+(NSString *)emptyStringReplaceZero:(id)string;
+(NSString *)zeroReplayEmptyString:(id)string;

//手机号
+ (BOOL)isValidateMobileNumber:(NSString *)text;
//密码
+ (BOOL)isValidateSecret:(NSString *)text;
//是否为空
+(BOOL)isHasString:(id)string;

/**数字*/
+(BOOL)isNo:(NSString *)text;
/**小数*/
+(BOOL)isDecimalNo:(NSString *)text;

+(NSString *)getString:(id)string;

@end
