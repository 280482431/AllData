
//
//  lvfjSimpleDefine.h
//  GDKStock
//
//  Created by lvfeijun on 2017/6/19.
//  Copyright © 2017年 lvfj. All rights reserved.
//

/*****************************************************************
 * Define  Single class
 *****************************************************************/

#ifndef lvfjSingleDefine_h
#define lvfjSingleDefine_h

#define UserLoginModelFilePath      lvfjDocument(@"UserLoginModel.data")

#define lvfjApplication             [UIApplication sharedApplication]
#define lvfjKeyWindow               lvfjApplication.keyWindow
#define lvfjWindows                 lvfjApplication.windows
#define lvfjFirtWindow              [lvfjWindows firstObject]
#define lvfjLastWindow              [lvfjWindows lastObject]
//#define lvfjRootVCtl(window)        window.rootViewController
#define lvfjFirtRootVCtl             lvfjFirtWindow.rootViewController
//#define lvfjResetRootVCtl(ctl)      lvfjKeyRootVCtl=nil,lvfjKeyRootVCtl=ctl

#define lvfjStatusActivity(flag)    lvfjApplication.networkActivityIndicatorVisible=flag
#define lvfjAppDelegate             ((AppDelegate *)lvfjApplication.delegate)
#define lvfjmainBundle              [NSBundle mainBundle]
#define lvfjResourceType(name,type) [lvfjmainBundle pathForResource:name ofType:type]
#define lvfjPlistResource(name)     lvfjResourceType(name,@"plist")
#define lvfjPlistResourceDictionary(name)    lvfjResourceTypeDictionary(name,@"plist")
#define lvfjResourceTypeDictionary(name,type)    [NSDictionary dictionaryWithContentsOfFile:lvfjResourceType(name,type)]

#define lvfjUserDefaults            [NSUserDefaults standardUserDefaults]
#define lvfjFileManager             [NSFileManager defaultManager]

#define lvfjAppData                 [AppDefaultData shareAppData]
#define lvfjImageCache              [SDImageCache sharedImageCache] // 图片缓存实例工具 --- 取缓存图片和删缓存图片
#define lvfjNotificationCenter      [NSNotificationCenter defaultCenter]      // 应用通知中心

#define lvfjDocuments               NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
#define lvfjDocument(name)          [[lvfjDocuments lastObject] stringByAppendingPathComponent:name]
#define lvfjHiddenStatusBar(flag)   [lvfjApplication setStatusBarHidden:flag withAnimation:UIStatusBarAnimationNone]


#define lvfjweakSelf(weakSelf)       __weak __typeof(&*self) weakSelf = self   // 对象弱引用

#define lvfjLocalizedString(key) NSLocalizedStringFromTable(key,@"lvfjLocalizedString", nil)

#pragma mark log

#ifdef DEBUG
#define lvfjString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define lvfjLog(...) printf("%s [%s] 第%d行: %s\n",[[lvfjHelper getCurrentDate] UTF8String], [lvfjString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define lvfjLog(...)
#endif

#endif /* lvfjSingleDefine_h */
