
/*****************************************************************
 * +++ FileName: HttpTool.h
 * +++ ProjName: YBHttpTool
 * Created Time: 15/12/2 上午11:15
 * ---------------------------------------------------------------
 * 说明:网络请求工具类 -- 负责整个项目的所有HTTP请求
 *****************************************************************/

#import <UIKit/UIKit.h>
#import "HttpHeader.h"

typedef NS_ENUM(NSInteger, lvfjNetworkStatus) {
    lvfjNetworkStatusUnknown          = -1, //!< 未知网络
    lvfjNetworkStatusNotReachable     = 0,  //!< 没有网络(断网)
    lvfjNetworkStatusReachableViaWWAN = 1,  //!< 手机自带网络(2G/3G/4G)
    lvfjNetworkStatusReachableViaWiFi = 2,  //!< WIFI
};

typedef NSURLSessionTask lvfjSessionTask;
typedef NSURLSessionUploadTask lvfjUploadTask;
typedef NSURLSessionDownloadTask lvfjDownloadTask;

typedef void (^lvfjNetStatus)(lvfjNetworkStatus status);
typedef void (^lvfjSuccessBlock)(id responseObj);
typedef void (^lvfjFailureBlock)(NSError *error);
typedef void (^lvfjProgressBlock)(NSProgress *progress);
typedef void (^lvfjFormBodyBlock)(id <lvfjMultFormData> formData);
typedef void (^lvfjDownloadHandle)(NSURL *filePath, NSURLResponse *response, NSError *error);
typedef NSURL * (^lvfjDownloadPath)(NSURL *targetPath, NSURLResponse *response);

@interface HttpsSetting : NSObject
@property (  copy, nonatomic) NSString * https_cer_server;     //!< 服务端cer证书
@property (  copy, nonatomic) NSString * https_cer_server_psw; //!< 服务端cer证书密码
@property (  copy, nonatomic) NSString * https_p12_client;     //!< 客户端p12证书
@property (  copy, nonatomic) NSString * https_p12_client_psw; //!< 客户端p12证书密码
@property (assign, nonatomic) BOOL isTwoWayAuth;               //!< 是否双向验证(YES:双向，NO:单向,默认)
@end
@interface HttpTool : NSObject
#pragma mark - ------------HttpTool参数注入(在AppDelegate中实现)------------
+ (void)httpsSetting:(HttpsSetting *)setting;        //!< 使用自签证书(如果setting有值)
+ (void)requestTimeout:(NSTimeInterval)timeInterval; //!< 设置请求超时时间
+ (void)monitorNetworkStatus:(lvfjNetStatus)netStatus; //!< 实时监控网络状态
#pragma mark - ---------------网络请求方法---------------

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (lvfjSessionTask *)GET:(NSString *)url params:(NSDictionary *)params success:(lvfjSuccessBlock)success failure:(lvfjFailureBlock)failure;

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (lvfjSessionTask *)POST:(NSString *)url params:(NSDictionary *)params success:(lvfjSuccessBlock)success failure:(lvfjFailureBlock)failure;

/**
 *  发送一个POST请求上传一张或者多张图片等数据
 *
 *  @param url       请求路径
 *  @param params    请求参数
 *  @param bodyBlock 多值block --- 上传参数
 *  @param success   请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure   请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (lvfjSessionTask *)POST:(NSString *)url params:(NSDictionary *)params formBody:(lvfjFormBodyBlock)bodyBlock success:(lvfjSuccessBlock)success failure:(lvfjFailureBlock)failure;

/**
 *  发送一个POST请求上传一张或者多张图片等数据 --- 含上传进度
 *
 *  @param url       请求路径
 *  @param params    请求参数
 *  @param bodyBlock 多值block --- 上传参数
 *  @param progress  上传进度
 *  @param success   请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure   请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+ (lvfjSessionTask *)POST:(NSString *)url params:(NSDictionary *)params formBody:(lvfjFormBodyBlock)bodyBlock progress:(lvfjProgressBlock)progressBlock success:(lvfjSuccessBlock)success failure:(lvfjFailureBlock)failure;

#pragma mark - ------------断点下载------------
/**
 *  断点下载
 *
 *  @param url        请求路径
 *  @param path       文件下载路径 --- 指定路径 targetPath:临时文件下载路径 filePath:最终文件下载路径
 *  @param progress   下载进度
 *  @param completion 下载完成后的回调（请将下载完成后想做的事情写到这个block中）
 */
+ (lvfjDownloadTask *)download:(NSString *)url path:(lvfjDownloadPath)downloadPath progress:(lvfjProgressBlock)progressBlock completion:(lvfjDownloadHandle)completionBlock;

/**
 *  同步下载图片
 */
+ (NSArray *)dowloadImgs:(NSArray *)urlArray;

#pragma mark - -----------基本功能方法------------

/**
 *  取消当前正在执行的请求操作(任务)
 */
+ (void)cancleRequestTask:(lvfjSessionTask *)task;

/**
 *  取消所有正在执行的请求操作(任务) --- 不包含下载或上传任务
 */
+ (void)cancleAllRequestTasks;

/**
 *  暂停当前正在执行的请求操作(任务)  --- 主要用在下载任务的暂停
 */
+ (void)suspendRequestTask:(lvfjSessionTask *)task;

/**
 *  继续(开始)当前正在执行的请求操作(任务)   --- 主要用在下载任务的开始
 */
+ (void)resumeRequestTask:(lvfjSessionTask *)task;

/**
 *  暂停当所有在执行的下载请求操作(任务)
 */
+ (void)suspendAllDownloadTask;

/**
 *  继续所有正在执行的下载请求操作(任务)
 */
+ (void)resumeAllDownloadTask;

@end
