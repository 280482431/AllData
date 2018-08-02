
/*****************************************************************
 * +++ FileName: MBProgressHUD+Michael.h
 * +++ ProjName: GDKStock
 * ++++ Company: 国都快易科技（深圳）有限公司
 * Created Time: 15/10/8 上午10:15
 * ---------------------------------------------------------------
 * 说明:Toast展示分类
 *****************************************************************/


#import "MBProgressHUD.h"

@interface MBProgressHUD (lvfj)

+ (void)showTips:(NSString *)tips toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
