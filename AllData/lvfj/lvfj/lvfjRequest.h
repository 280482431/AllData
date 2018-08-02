//
//  lvfjRequest.h
//  AllData
//
//  Created by lvfeijun on 2018/5/18.
//  Copyright © 2018年 lvfeijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpTool.h"

static NSString * const  RequestTypeShowNone    = @"RequestTypeShowNone";
static NSString * const  RequestTypeShowAll     =  @"RequestTypeShowAll";
static NSString * const  RequestTypeShowSuccess  = @"RequestTypeShowSuccess";
static NSString * const  RequestTypeShowFailure  = @"RequestTypeShowFailure";
static NSString * const  RequestTypeShowError    = @"RequestTypeShowError";

static NSString * const RequestTypeShowProcessInView  =   @"RequestTypeShowProcessInView";
static NSString * const RequestTypeShowProcessInNavigation  =   @"RequestTypeShowProcessInNavigation";

static NSString * const RequestTypeInnerParamer  =  @"RequestTypeInnerParamer";

@interface lvfjRequest : NSObject

+(lvfjSessionTask *)POSTurl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure arrayType:(NSArray *)arrayType vctl:(UIViewController *)vctl;

+(BOOL)isRetureSuccess:(NSDictionary *)dic;

@end
