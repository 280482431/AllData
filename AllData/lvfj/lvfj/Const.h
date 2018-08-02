
/*****************************************************************
 * +++ FileName: Const.h
 * +++ ProjName: KEXStock
 * +++++ Author: .
 * +++++ E-Mail: .
 * ++++ Company: 国都快易科技（深圳）有限公司
 * Created Time: 15/6/1 上午11:15
 * ---------------------------------------------------------------
 * 说明:常量(自定义常量，不是宏常量)
 *****************************************************************/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifndef ____Const_h
#define ____Const_h

#pragma mark - 常用block
typedef void (^UpdateExDataBlock)(CGFloat dataValue);
typedef void (^UpdateModelDataBlock)(id model);
typedef void (^UpdateDataBlock)(BOOL boolValue);
typedef void (^GetUserExDataBlock)(NSString * accountId, NSString * sessionId, NSString * realName);
typedef void (^OtherLoginBlock)(NSString * openID, NSString * figureurl, NSString * nickName, NSString * otherType);

#pragma mark - 常用常量值
UIKIT_EXTERN NSString * const GDKMarketTitle;        //!< 市场模块标题
UIKIT_EXTERN NSString * const GDKExLoginTitle;       //!< 交易登录标题
UIKIT_EXTERN NSString * const GDKExchangeTitle;      //!< 交易模块标题
UIKIT_EXTERN NSString * const GDKDiscoverTitle;      //!< 发现模块标题
UIKIT_EXTERN NSString * const GDKInfoTitle;          //!< 资讯模块标题
UIKIT_EXTERN NSString * const GDKPersonalTitle;      //!< 个人模块标题
UIKIT_EXTERN NSString * const kVersionKey;           //!< app版本号关键字
UIKIT_EXTERN NSString * const kAppDisplayNameKey;
UIKIT_EXTERN NSString * const kAppNameKey;           //!< app名称关键字
UIKIT_EXTERN NSString * const kReachURLStrBaiDu;     //!< 测试网络能否连通使用的测试地址 --- 百度
UIKIT_EXTERN NSString * const kReachURLStrKEXServer; //!< 测试网络能否连通使用的测试地址 --- 快易网
UIKIT_EXTERN NSString * const kGDKAppKey;            //!< 专用的APPKey(与第三方无关，目的是为了防止抓包)
UIKIT_EXTERN NSString * const kGDKTardeKey;          //!< 绑定交易账号时使用

#pragma mark - 交易登录常量
UIKIT_EXTERN NSString * const kTradeUserName;        //!< 交易用户名key
UIKIT_EXTERN NSString * const kSaveTradeUserNameList;//!< 保留的交易用户名列表

#pragma mark - 平台登录常量
UIKIT_EXTERN NSString * const kUserMobile;           //!< 用户手机号码(交易登录时的用户账户关键字)
UIKIT_EXTERN NSString * const kUserInfoData;         //!< 用户信息数据(用户登录注册的关键字)
UIKIT_EXTERN NSString * const kUserOpenID;           //!< 用户OpenID(用于第三方登录身份校验)
UIKIT_EXTERN NSString * const kMobleLogin;           //!< 手机登陆方式
UIKIT_EXTERN NSString * const kOtherLogin;           //!< 第三方登录方式
UIKIT_EXTERN NSString * const kIsOtherLogin;         //!< 是否为第三方登录
UIKIT_EXTERN NSString * const kLastTelphone;         //!< 上次登录使用的手机号码
UIKIT_EXTERN NSString * const kPLoginModel;          //!< 用户平台登录模型
UIKIT_EXTERN NSString * const kVerifyCodeMD5Sever;   //!< 服务器发送过来的短信验证码MD5值
UIKIT_EXTERN NSString * const kUid;                  //!< 用户uid
UIKIT_EXTERN NSString * const kUserTradeId;          //!< 用户交易id
UIKIT_EXTERN NSString * const kUserToken;            //!< 用户平台token
UIKIT_EXTERN NSString * const kTokenExpireAt;        //!< 用户平台token过期日期 --- 用于平台登录过期判断
UIKIT_EXTERN NSString * const kPLoginDirect;         //!< 用户平台登录 --- 登录方向(如：iOS、Android、快易网)

#pragma mark - 第三方注册类型(仅用于平台,不再和友盟相关)
UIKIT_EXTERN NSString * const GDKLoginToWechat;      //!< 用户平台登录(注册) --- 使用交易账号登录(注册)
UIKIT_EXTERN NSString * const GDKLoginToQQ;          //!< 用户平台登录(注册) --- 使用QQ账号登录(注册)
UIKIT_EXTERN NSString * const GDKLoginToSina;        //!< 用户平台登录(注册) --- 使用微博账号登录(注册)
UIKIT_EXTERN NSString * const GDKLoginToTrade;       //!< 用户平台登录(注册) --- 使用交易账号登录(注册)

#pragma mark - AES\DES加密向量(iv)和秘钥(key)
UIKIT_EXTERN NSString * const kDesIV;                //!< DES加密向量
UIKIT_EXTERN NSString * const kDesKey;               //!< DES机密key
UIKIT_EXTERN NSString * const kAesIV;                //!< AES加密向量
UIKIT_EXTERN NSString * const kAesKey;               //!< AES机密key

#pragma mark - 股票行情
UIKIT_EXTERN NSString * const kNilData;              //!< 空数据 --
UIKIT_EXTERN NSString * const kXjSortState;          //!< 按照现价的排序状态
UIKIT_EXTERN NSString * const kZdfSortState;         //!< 按照涨跌幅的排序状态
UIKIT_EXTERN NSString * const kOptSortStateData;     //!< 存放自选排序状态数据的data对象
UIKIT_EXTERN NSString * const kZdfRiseState;         //!< 涨状态
UIKIT_EXTERN NSString * const kZdfFallState;         //!< 跌状态
UIKIT_EXTERN NSString * const kZdfFlatState;         //!< 不涨不跌状态
UIKIT_EXTERN NSString * const kZdfRiseColor;         //!< 涨颜色
UIKIT_EXTERN NSString * const kZdfFallColor;         //!< 跌颜色
UIKIT_EXTERN NSString * const kZdfFlatColor;         //!< 不涨不跌颜色(flat:平坦的，平直的)
UIKIT_EXTERN NSString * const kZdfCheckedIndex;      //!< 选中的索引号
UIKIT_EXTERN NSString * const kZdfDisplayStr;        //!< 显示设置右边显示的字符串
UIKIT_EXTERN NSString * const kZdfColorData;         //!< 存放颜色数据的data对象

UIKIT_EXTERN NSString * const kIsShowExceptions;     //!< 是否显示免责条款(Exceptions)
UIKIT_EXTERN NSString * const kSeenExceptionsDict;   //!< 是否查看过免责条款字典
UIKIT_EXTERN NSString * const kHSExponentCode;       //!< 恒生指数代码
UIKIT_EXTERN NSString * const kGQExponentCode;       //!< 国企指数代码
UIKIT_EXTERN NSString * const kHCExponentCode;       //!< 红筹指数代码

UIKIT_EXTERN NSInteger const kViewBtnTag;            //!< 查看按钮tag值
UIKIT_EXTERN NSInteger const kComtBtnTag;            //!< 评论按钮tag值
UIKIT_EXTERN NSInteger const kShareBtnTag;           //!< 分享按钮tag值
UIKIT_EXTERN NSInteger const kLikeBtnTag;            //!< 点赞按钮tag值

#pragma mark - 第三方框架 --- 应用事件统计

UIKIT_EXTERN NSString * const kAppChannel;           //!< App发布渠道
UIKIT_EXTERN NSString * const BaiduEvent01;          //!< 查看了一支股票
UIKIT_EXTERN NSString * const BaiduEvent02;          //!< 关注了一支股票
UIKIT_EXTERN NSString * const BaiduEvent03;          //!< 取消关注了一支股票
UIKIT_EXTERN NSString * const BaiduEvent04;          //!< 点击了买入按钮
UIKIT_EXTERN NSString * const BaiduEvent05;          //!< 点击了卖出按钮
UIKIT_EXTERN NSString * const BaiduEvent06;          //!< 查看了个股新闻
UIKIT_EXTERN NSString * const BaiduEvent07;          //!< 点击了免费开户
UIKIT_EXTERN NSString * const BaiduEvent08;          //!< 买入下单成功
UIKIT_EXTERN NSString * const BaiduEvent09;          //!< 买入下单失败
UIKIT_EXTERN NSString * const BaiduEvent10;          //!< 卖出下单成功
UIKIT_EXTERN NSString * const BaiduEvent11;          //!< 卖出下单失败
UIKIT_EXTERN NSString * const BaiduEvent12;          //!< 买入改单成功
UIKIT_EXTERN NSString * const BaiduEvent13;          //!< 买入改单失败
UIKIT_EXTERN NSString * const BaiduEvent14;          //!< 卖出改单成功
UIKIT_EXTERN NSString * const BaiduEvent15;          //!< 卖出改单失败
UIKIT_EXTERN NSString * const BaiduEvent16;          //!< 买入撤单成功
UIKIT_EXTERN NSString * const BaiduEvent17;          //!< 买入撤单失败
UIKIT_EXTERN NSString * const BaiduEvent18;          //!< 卖出撤单成功
UIKIT_EXTERN NSString * const BaiduEvent19;          //!< 卖出撤单失败
UIKIT_EXTERN NSString * const BaiduEvent20;          //!< 点赞一条动态成功
UIKIT_EXTERN NSString * const BaiduEvent21;          //!< 点赞一条动态失败
UIKIT_EXTERN NSString * const BaiduEvent22;          //!< 点赞一条评论成功
UIKIT_EXTERN NSString * const BaiduEvent23;          //!< 点赞一条评论失败
UIKIT_EXTERN NSString * const BaiduEvent24;          //!< 评论一条动态成功
UIKIT_EXTERN NSString * const BaiduEvent25;          //!< 评论一条动态失败
UIKIT_EXTERN NSString * const BaiduEvent26;          //!< 发布一条动态成功
UIKIT_EXTERN NSString * const BaiduEvent27;          //!< 发布一条动态失败
UIKIT_EXTERN NSString * const BaiduEvent28;          //!< 点赞一条直播数据成功
UIKIT_EXTERN NSString * const BaiduEvent29;          //!< 点赞一条直播数据失败
UIKIT_EXTERN NSString * const BaiduEvent30;          //!< 分享了一支股票
UIKIT_EXTERN NSString * const BaiduEvent31;          //!< 分享了一条动态
UIKIT_EXTERN NSString * const BaiduEvent32;          //!< 分享了一条直播数据
UIKIT_EXTERN NSString * const BaiduEvent33;          //!< 分享了一条豹宝学堂数据
UIKIT_EXTERN NSString * const BaiduEvent34;          //!< 分享了一条豹宝话市数据
UIKIT_EXTERN NSString * const BaiduEvent35;          //!< 查看了一条置顶消息
UIKIT_EXTERN NSString * const BaiduEvent36;
UIKIT_EXTERN NSString * const BaiduEvent37;

#pragma mark - 网络域名地址
UIKIT_EXTERN NSString * const kGDKRequestPOSTKey;     //!< 发送POST请求时的键值
UIKIT_EXTERN NSString * const kGDKMarketDomainName;   //!< 市场行情信息域名地址
UIKIT_EXTERN NSString * const kGDKGuideDomainName;    //!< 社交数据域名地址

#pragma mark - 通知

#pragma mark - 常用枚举值
typedef NS_ENUM(NSInteger, kZdState) {
    kZdStateRed = 0,              //!< 涨状态值 --- 红涨
    kZdStateGreen,                //!< 跌状态值 --- 绿跌
};

typedef NS_ENUM (NSUInteger, GuideCellType) {
    GuideCellTypeLogin = 100,     //!< 登录
    GuideCellTypeConnection,      //!< 关联账户
    
    GuideCellTypeRegister,        //!< 注册
    GuideCellTypeFindPassword,    //!< 找回密码
    GuideCellTypeResetPassword,   //!< 重设密码
    GuideCellTypeUserInfo         //!< 设置用户信息
};

typedef NS_ENUM(NSInteger, ExBindCellType) {
    ExBindCellTypeLogin = 30,     //!< 交易账户绑定
    ExBindCellTypeUnlock,         //!< 交易账户解锁
};

#endif
