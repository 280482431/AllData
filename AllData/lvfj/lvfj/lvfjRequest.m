//
//  lvfjRequest.m
//  AllData
//
//  Created by lvfeijun on 2018/5/18.
//  Copyright © 2018年 lvfeijun. All rights reserved.
//

#import "lvfjRequest.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+lvfj.h"
#import "MBProgressHUD+Michael.h"
#import "lvfjStringUtils.h"
#import "lvfjSingleDefine.h"

@implementation lvfjRequest

+(lvfjSessionTask *)POSTurl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure arrayType:(NSArray *)arrayType vctl:(UIViewController *)vctl{
    
    [lvfjRequest innerBeforeRequstWithArrayType:arrayType vctl:vctl];
    __weak typeof(vctl) wSelf = vctl;
    
    return [HttpTool POST:url params:parameters success:^(id responseObj) {
        [lvfjRequest innerRequstSuccessWithArrayType:arrayType vctl:wSelf responseObj:responseObj success:success];
    } failure:^(NSError *error) {
        [lvfjRequest innerRequstErrorWithArrayType:arrayType vctl:wSelf error:error failure:failure];
    }];
}

+(void)innerBeforeRequstWithArrayType:(NSArray *)type vctl:(UIViewController *)vctl{
    lvfjStatusActivity(YES);
    
    if ([type containsObject:RequestTypeShowProcessInNavigation]) {
        [lvfjRequest showProcessHUD:lvfjLocalizedString(@"PleaseWait") vctl:vctl];
    }
    else if ([type containsObject:RequestTypeShowProcessInView]) {
        [MBProgressHUD showMessage:lvfjLocalizedString(@"PleaseWait") toView:vctl.view].dimBackground = NO;
    }
}

+(void)innerAfterRequstWithArrayType:(NSArray *)type vctl:(UIViewController *)vctl{
    lvfjStatusActivity(NO);
    
    if ([type containsObject:RequestTypeShowProcessInNavigation]) {
        [lvfjRequest hideProcessHUD:vctl];
    }
    else if ([type containsObject:RequestTypeShowProcessInView]) {
        [MBProgressHUD hideHUDForView:vctl.view animated:YES];
    }
}

+(void)innerRequstSuccessWithArrayType:(NSArray *)arrayType vctl:(UIViewController *)vctl responseObj:(id)responseObj success:(lvfjSuccessBlock)success{
    [lvfjRequest innerAfterRequstWithArrayType:arrayType vctl:vctl];
    
    //dic
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingAllowFragments error:nil];
//    if ([dic[@"code"]integerValue]==kUserTokenExpiredCode) {
//        [lvfjRequest tokenExpired];
//    }
//    else if ([lvfjBusiness isTradeTokenExpired:dic]) {
//        if (lvfjAppDelegate.logOutExchange) {
//            [lvfjAlertView alertTitle:[lvfjStringUtils emptyStringReplaceNSNull:dic[@"message"]] tapBlock:^{
//                lvfjAppDelegate.logOutExchange(NO);
//            }];
//        }
//        else{
//            [lvfjBusiness showMessage:[lvfjBusiness getMessage:dic] inView:vctl.view];
//        }
//    }
//    else{
        if (success) {
            success(dic);
//            lvfjLog(@"%@",dic);
        }
        if ([lvfjRequest isRetureSuccess:dic]) {
            if ([arrayType containsObject:RequestTypeShowSuccess]) {
                [lvfjRequest showMessage:@"成功" inView:vctl.view];
            }
        }
        else{
            if ([arrayType containsObject:RequestTypeShowFailure]||[arrayType containsObject:RequestTypeShowAll]) {
                [lvfjRequest showMessage:[lvfjRequest getMessage:dic] inView:vctl.view];
            }
        }
//    }
}

+(BOOL)isRetureSuccess:(NSDictionary *)dic{
    return [dic[@"error_code"] integerValue]==0;
}

+(void)innerRequstErrorWithArrayType:(NSArray *)arrayType vctl:(UIViewController *)vctl error:(NSError *)error failure:(lvfjFailureBlock)failure{
    [lvfjRequest innerAfterRequstWithArrayType:arrayType vctl:vctl];
    
    if (failure) {
        failure(error);
    }
    
    if ([arrayType containsObject:RequestTypeShowError]||[arrayType containsObject:RequestTypeShowAll]) {
        [lvfjRequest showMessage:[lvfjRequest getRequestErrorMessage:error] inView:vctl.view];
    }
}

+ (void)showMessage:(NSString *)msg inView:(UIView *)view{
    [MBProgressHUD showError:msg toView:view];
}

+(NSString *)getMessage:(NSDictionary *)dic{
    NSString *msg = dic[@"reason"];
    if ([lvfjStringUtils isEmptyString:msg]) {
        msg = @"未知错误";
    }
    return msg;
}

+(NSString *)getRequestErrorMessage:(NSError *)error{
    //    NSString *str = [lvfjStringUtils isEmptyString:error.localizedDescription]?@"请求失败":error.localizedDescription;
    //    if (error.code == -1009){
    //        str = @"似乎已断开了与互联网的连接。";
    //    }else if (error.code == 3840){
    //        str = @"非 Json 格式";
    //    }
    //    return str;
    return @"网络故障，请稍后重试";
}

+ (void)showProcessHUD:(NSString *)text vctl:(UIViewController *)vctl
{
    if ([vctl isKindOfClass:[UINavigationController class]]&&vctl.tabBarController) {
        [MBProgressHUD showHUDAddedTo:vctl.view text:text animated:YES];
    }
    else if(vctl.navigationController){
        [MBProgressHUD showHUDAddedTo:vctl.navigationController.view text:text animated:YES];
    }
}

+ (void)hideProcessHUD:(UIViewController *)vctl
{
    //隐藏self.view的HUD
    NSArray *HUDArr1 = [MBProgressHUD allHUDsForView:vctl.view];
    if (HUDArr1.count != 0) {
        [MBProgressHUD hideAllHUDsForView:vctl.view animated:YES];
    }
    //隐藏self.navigationController.view的HUD
    NSArray *HUDArr2 = [MBProgressHUD allHUDsForView:vctl.navigationController.view];
    if (HUDArr2.count != 0) {
        [MBProgressHUD hideAllHUDsForView:vctl.navigationController.view animated:YES];
    }
    
    /*PS:可能需要扩展隐藏其他View的HUD*/
    
    //    if ([self isKindOfClass:[UINavigationController class]]) {
    //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    }
    //    else if(self.navigationController){
    //        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    //    }
}

@end
