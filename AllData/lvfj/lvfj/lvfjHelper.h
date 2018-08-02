//
//  lvfjHelper.h
//  GDKStock
//
//  Created by lvfeijun on 2017/4/26.
//  Copyright © 2017年 lvfj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lvfjHelper : NSObject

+(BOOL)isUpdateForKey:(NSString *)key;
+(void)saveUpdateForKey:(NSString *)key;
+(id)getUserDefaultsObjForKey:(NSString *)key;
+(void)setUserDefaultsObj:(id)obj forKey:(NSString *)key;
+ (NSString *)getCurrentDate;

@end
