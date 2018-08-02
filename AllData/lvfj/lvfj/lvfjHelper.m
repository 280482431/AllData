//
//  lvfjHelper.m
//  GDKStock
//
//  Created by lvfeijun on 2017/4/26.
//  Copyright © 2017年 lvfj. All rights reserved.
//

#define kupdateAppVersion   @"kupdateAppVersion"

#import "lvfjHelper.h"
#import "lvfjStringUtils.h"
#import "lvfjSingleDefine.h"
//#import "lvfjNewVersionView.h"

@implementation lvfjHelper

#pragma mark normal

+(id)getUserDefaultsObjForKey:(NSString *)key{
    return [lvfjUserDefaults objectForKey:key];
}

+(void)setUserDefaultsObj:(id)obj forKey:(NSString *)key{
    [lvfjUserDefaults setObject:obj forKey:key];
    [lvfjUserDefaults synchronize];
}

//+(BOOL)isUpdateForKey:(NSString *)key{
////    NSDictionary *appVersionDic = [lvfjHelper getUserDefaultsObjForKey:key];
////    BOOL result = appVersionDic.count>0;
////    if (result) {
////        result = [lvfjAppData.appVersion isEqualToString:appVersionDic[key]];
////    }
//    NSString *version = [lvfjHelper getUserDefaultsObjForKey:key];
//    return [lvfjStringUtils isEmptyString:version]||![lvfjAppData.appVersion isEqualToString:version];
//}

//+(void)saveUpdateForKey:(NSString *)key{
//    if ([lvfjHelper isUpdateForKey:key]) {
//        [lvfjHelper setUserDefaultsObj:lvfjAppData.appVersion forKey:key];
//    }
//}

+(NSString *)getCurrentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}



@end
