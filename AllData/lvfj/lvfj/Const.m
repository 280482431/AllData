
/*****************************************************************
 * +++ FileName: Const.m
 * +++ ProjName: KEXStock
 * +++++ Author: .
 * +++++ E-Mail: .
 * ++++ Company: 国都快易科技（深圳）有限公司
 * Created Time: 15/6/1 上午11:15
 * ---------------------------------------------------------------
 * 说明:常量(自定义常量，不是宏常量)
 *****************************************************************/

#import "Const.h"

#pragma mark - 常用常量值
NSString * const GDKMarketTitle        = @"行情";
NSString * const GDKExchangeTitle      = @"交易";
NSString * const GDKExLoginTitle       = @"交易登录";
NSString * const GDKDiscoverTitle      = @"发现";
NSString * const GDKInfoTitle          = @"资讯";
NSString * const GDKPersonalTitle      = @"个人";

NSString * const kAppDisplayNameKey    = @"CFBundleDisplayName";
NSString * const kVersionKey           = @"CFBundleVersion";
NSString * const kAppNameKey           = @"CFBundleName";// @"CFBundleDisplayName"
NSString * const kReachURLStrBaiDu     = @"www.baidu.com";
NSString * const kReachURLStrKEXServer = @"www.kuaiex.com";
NSString * const kGDKAppKey            = @"ccdc177b8bcb69260f5176e381046654";
NSString * const kGDKTardeKey = @"$2y$10$wO8gytEvLo/.0q1nMUXV5emK6nsL8GRhkNj8k9EOrhJZLpwY1GTVO";

#pragma mark - 交易登录常量
NSString * const kTradeUserName     = @"tradeUserName";
NSString * const kSaveTradeUserNameList     = @"kSaveTradeUserNameList";

#pragma mark - 平台登录常量
NSString * const kUserMobile         = @"userMobile";
NSString * const kUserInfoData       = @"userInfoData" ;
NSString * const kUserOpenID         = @"otherLoginOpenID";
NSString * const kMobleLogin         = @"mobleLogin";
NSString * const kOtherLogin         = @"otherLogin";
NSString * const kIsOtherLogin       = @"isOtherLogin";
NSString * const kLastTelphone       = @"lastTelphone";
NSString * const kPLoginModel        = @"pLoginModel";
NSString * const kVerifyCodeMD5Sever = @"verifyCodeMD5Sever";
NSString * const kUid                = @"uid";
NSString * const kUserTradeId        = @"trade";
NSString * const kUserToken          = @"token";
NSString * const kTokenExpireAt      = @"expire_at";
NSString * const kPLoginDirect       = @"login_type";

#pragma mark - 第三方注册类型(仅用于平台,不再和友盟相关)
NSString * const GDKLoginToWechat     = @"wxsession";
NSString * const GDKLoginToQQ         = @"qq";
NSString * const GDKLoginToSina       = @"sina";
NSString * const GDKLoginToTrade      = @"trade";

NSString * const kDesIV              = @"0f00rh03";              //!< DES加密向量
NSString * const kDesKey             = @"1f4ea6aa";              //!< DES机密key
NSString * const kAesIV              = @"0f00rh0300c00a00";      //!< AES加密向量
NSString * const kAesKey             = @"1f4ea6aaf637c2cb";      //!< AES加密key abf006433b69b6f4

#pragma mark - 股票行情
NSString * const kNilData            = @"--";
NSString * const kXjSortState        = @"xjSortState";
NSString * const kZdfSortState       = @"zdfSortState";
NSString * const kOptSortStateData   = @"optionalSortStateData";
NSString * const kZdfRiseState       = @"riseState";
NSString * const kZdfFallState       = @"fallState";
NSString * const kZdfFlatState       = @"flatState";
NSString * const kZdfRiseColor       = @"riseColor";
NSString * const kZdfFallColor       = @"fallColor";
NSString * const kZdfFlatColor       = @"flatColor";
NSString * const kZdfCheckedIndex    = @"checkedIndex";
NSString * const kZdfDisplayStr      = @"zdfDisplayStr";
NSString * const kZdfColorData       = @"zdfColorData";
NSString * const kIsShowExceptions   = @"isDisplayExceptionsClause";
NSString * const kSeenExceptionsDict = @"seenExceptionsClauseDict";

NSString * const kHSExponentCode     = @"EHSI";
NSString * const kGQExponentCode     = @"EHSCEI";
NSString * const kHCExponentCode     = @"EHSCCI";

NSInteger const kViewBtnTag  = 100;
NSInteger const kComtBtnTag  = 101;
NSInteger const kShareBtnTag = 102;
NSInteger const kLikeBtnTag  = 103;

#pragma mark - 第三方框架 --- 应用事件统计

NSString * const kAppChannel      = @"App Store";
NSString * const BaiduEvent01 = @"Event01";
NSString * const BaiduEvent02 = @"Event02";
NSString * const BaiduEvent03 = @"Event03";
NSString * const BaiduEvent04 = @"Event04";
NSString * const BaiduEvent05 = @"Event05";
NSString * const BaiduEvent06 = @"Event06";
NSString * const BaiduEvent07 = @"Event07";
NSString * const BaiduEvent08 = @"Event08";
NSString * const BaiduEvent09 = @"Event09";
NSString * const BaiduEvent10 = @"Event10";
NSString * const BaiduEvent11 = @"Event11";
NSString * const BaiduEvent12 = @"Event12";
NSString * const BaiduEvent13 = @"Event13";
NSString * const BaiduEvent14 = @"Event14";
NSString * const BaiduEvent15 = @"Event15";
NSString * const BaiduEvent16 = @"Event16";
NSString * const BaiduEvent17 = @"Event17";
NSString * const BaiduEvent18 = @"Event18";
NSString * const BaiduEvent19 = @"Event19";
NSString * const BaiduEvent20 = @"Event20";
NSString * const BaiduEvent21 = @"Event21";
NSString * const BaiduEvent22 = @"Event22";
NSString * const BaiduEvent23 = @"Event23";
NSString * const BaiduEvent24 = @"Event24";
NSString * const BaiduEvent25 = @"Event25";
NSString * const BaiduEvent26 = @"Event26";
NSString * const BaiduEvent27 = @"Event27";
NSString * const BaiduEvent28 = @"Event28";
NSString * const BaiduEvent29 = @"Event29";
NSString * const BaiduEvent30 = @"Event30";
NSString * const BaiduEvent31 = @"Event31";
NSString * const BaiduEvent32 = @"Event32";
NSString * const BaiduEvent33 = @"Event33";
NSString * const BaiduEvent34 = @"Event34";
NSString * const BaiduEvent35 = @"Event35";
NSString * const BaiduEvent36;
NSString * const BaiduEvent37;

#pragma mark - 网络域名地址
NSString * const kGDKRequestPOSTKey     = @"10001";
NSString * const kGDKGuideDomainName    = @"http://api.sainiuhui.com";
NSString * const kGDKMarketDomainName   = @"http://hq2.kuaiex.hk";

#pragma mark - 通知
