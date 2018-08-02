
/*****************************************************************
 * +++ FileName: MBProgressHUD+Michael.m
 * +++ ProjName: GDKStock
 * ++++ Company: 国都快易科技（深圳）有限公司
 * Created Time: 15/10/8 上午10:15
 * ---------------------------------------------------------------
 * 说明:Toast展示分类
 *****************************************************************/

#import "MBProgressHUD+lvfj.h"
#import "lvfjSingleDefine.h"
//#import "lvfjConst.h"

@implementation MBProgressHUD (lvfj)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (!view) view = lvfjLastWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.7];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showTips:(NSString *)tips toView:(UIView *)view
{
    if (!view) view = lvfjLastWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = tips;
    hud.customView = [[UIView alloc] init];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.7];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (!view) view = lvfjLastWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+(id)lvfjSharedInstance
{
    static MBProgressHUD *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MBProgressHUD alloc] init];
    });
    return sharedInstance;
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = lvfjLastWindow;
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

@end
