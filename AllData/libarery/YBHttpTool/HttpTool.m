
/*****************************************************************
 * +++ FileName: HttpTool.m
 * +++ ProjName: YBHttpTool
 * Created Time: 15/12/2 上午11:15
 * ---------------------------------------------------------------
 * 说明:网络请求工具类 -- 负责整个项目的所有HTTP请求
 *****************************************************************/

#import "HttpTool.h"
#import "lvfjSingleDefine.h"

#define ktimeInterval   10

#define YB_WS(weakSelf)  __weak __typeof(&*self) weakSelf = self
typedef AFHTTPSessionManager HttpManager;
typedef AFNetworkReachabilityManager YBNetManager;
@implementation HttpsSetting
@end
@interface HttpTool ()
@property (strong, nonatomic) HttpManager * manager;
@property (strong, nonatomic) YBNetManager * netMgr;
@property (strong, nonatomic) lvfjSessionTask * sTask; 
@property (strong, nonatomic) lvfjUploadTask * uTask; 
@property (strong, nonatomic) lvfjDownloadTask * dTask; 
@property (strong, nonatomic) HttpsSetting * httpsData;
@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (assign, nonatomic) BOOL isTimeOutSetted;
@end
@implementation HttpTool
static HttpTool * httpTool = nil;
+ (HttpTool *)httpTool
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
       
    }
    return httpTool = self;
}

+ (void)httpsSetting:(HttpsSetting *)setting
{
    if (!httpTool) httpTool = [HttpTool httpTool];
    if (!httpTool.httpsData) {
        httpTool.httpsData = setting;
    }
}

+ (void)requestTimeout:(NSTimeInterval)timeInterval
{
    if (!httpTool) httpTool = [HttpTool httpTool];
    if (!httpTool.isTimeOutSetted) {
        httpTool.timeInterval = timeInterval;
        httpTool.isTimeOutSetted = YES;
    }
}

+ (void)monitorNetworkStatus:(lvfjNetStatus)netStatus
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!httpTool) httpTool = [HttpTool httpTool];
        [httpTool.netMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (netStatus) {
                if (status == AFNetworkReachabilityStatusUnknown) {
                    netStatus(lvfjNetworkStatusUnknown);
                } else if (status == AFNetworkReachabilityStatusNotReachable) {
                    netStatus(lvfjNetworkStatusNotReachable);
                } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
                    netStatus(lvfjNetworkStatusReachableViaWWAN);
                } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                    netStatus(lvfjNetworkStatusReachableViaWiFi);
                }
            } else {
                NSLog(@"没有传递网络监控block");
            }
        }];
    });
}

+ (lvfjSessionTask *)GET:(NSString *)url params:(NSDictionary *)params success:(lvfjSuccessBlock)success failure:(lvfjFailureBlock)failure
{
    if (!httpTool) httpTool = [HttpTool httpTool];
    HttpManager * manager = httpTool.manager;
    httpTool.sTask = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObj) {
        if (success) success(responseObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    return httpTool.sTask;
}

+ (lvfjSessionTask *)POST:(NSString *)url params:(NSDictionary *)params success:(lvfjSuccessBlock)success failure:(lvfjFailureBlock)failure
{
    if (!httpTool) httpTool = [HttpTool httpTool];
    HttpManager * manager = httpTool.manager;
    httpTool.sTask = [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObj) {
        if (success) success(responseObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    return httpTool.sTask;
}

+ (lvfjSessionTask *)POST:(NSString *)url params:(NSDictionary *)params formBody:(lvfjFormBodyBlock)bodyBlock success:(lvfjSuccessBlock)success failure:(lvfjFailureBlock)failure
{
    return [self POST:url params:params formBody:bodyBlock progress:nil success:success failure:failure];
}

+ (lvfjSessionTask *)POST:(NSString *)url params:(NSDictionary *)params formBody:(lvfjFormBodyBlock)bodyBlock progress:(lvfjProgressBlock)progressBlock success:(lvfjSuccessBlock)success failure:(lvfjFailureBlock)failure
{
    if (!httpTool) httpTool = [HttpTool httpTool];
    HttpManager * manager = httpTool.manager;
    httpTool.sTask = [manager POST:url parameters:params constructingBodyWithBlock:bodyBlock progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressBlock) progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObj) {
        if (success) success(responseObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    return httpTool.sTask;
}

+ (lvfjDownloadTask *)download:(NSString *)url path:(lvfjDownloadPath)downloadPath progress:(lvfjProgressBlock)progressBlock completion:(lvfjDownloadHandle)completionBlock
{
    if (!httpTool) httpTool = [HttpTool httpTool];
    HttpManager * manager = httpTool.manager;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    httpTool.dTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) progressBlock(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (downloadPath) return downloadPath(targetPath, response);
        NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString * pathStr = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:pathStr];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionBlock) completionBlock(filePath, response, error);
    }];
    [httpTool.dTask resume];
    return httpTool.dTask;
}

+ (NSArray *)dowloadImgs:(NSArray *)urlArray {
    __block NSMutableArray * array = [NSMutableArray array];
    [urlArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSURL * url = [NSURL URLWithString:obj];
        NSData * data = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:nil];
        UIImage * img = [UIImage imageWithData:data];
        [array addObject:img];
    }];
    return [NSArray arrayWithArray:array];
}

+ (void)cancleRequestTask:(lvfjSessionTask *)task
{
    if (task) [task cancel];
}

+ (void)cancleAllRequestTasks
{
    if (httpTool.manager) [httpTool.manager.dataTasks makeObjectsPerformSelector:@selector(cancel)];
}

+ (void)suspendRequestTask:(lvfjSessionTask *)task
{
    if (task) [task suspend];
}

+ (void)resumeRequestTask:(lvfjSessionTask *)task
{
    if (task) [task resume];
}

+ (void)suspendAllDownloadTask
{
    if (httpTool.manager) [httpTool.manager.downloadTasks makeObjectsPerformSelector:@selector(suspend)];
}

+ (void)resumeAllDownloadTask
{
    if (httpTool.manager) [httpTool.manager.downloadTasks makeObjectsPerformSelector:@selector(resume)];
}

+ (NSString *)encodeUrl:(NSString *)url
{
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void)updateTaskIdentifier
{
    [self httpTool];
}

- (YBNetManager *)netMgr
{
    if (!_netMgr) {
        if (!httpTool) httpTool = [HttpTool httpTool];
        _netMgr = [YBNetManager sharedManager];
        [_netMgr startMonitoring];
    }
    return _netMgr;
}

- (HttpManager *)manager
{
    if (!_manager) {
        if (!httpTool) httpTool = [HttpTool httpTool];
        _manager = [HttpTool manager:httpTool.httpsData];
        _manager.requestSerializer.timeoutInterval = httpTool.isTimeOutSetted?httpTool.timeInterval:ktimeInterval;
    }
    return _manager;
}

+ (HttpManager *)manager:(HttpsSetting *)setting
{
    NSArray * cntTypes = @[@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain",@"image/*"];
    HttpManager * manager = [HttpManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:cntTypes];
    if (setting) {
        manager = [self httpsAuth:manager setting:setting];
    } else {
        NSLog(@"没有传递服务端cer证书和客户端p12证书，不验证HTTPS，可能会取不到数据!");
        manager = [self httpsNotAuth:manager];
    }
    return manager;
}

+ (HttpManager *)httpsNotAuth:(HttpManager *)manager
{
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    return manager;
}

+ (HttpManager *)httpsAuth:(HttpManager *)manager setting:(HttpsSetting *)setting
{
    if (setting.https_cer_server.length) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSBundle * bundle = lvfjmainBundle;
        NSString *sever_cer_path = nil, *client_p12_path = nil;
        if ([setting.https_cer_server hasSuffix:@".cer"]) {
            sever_cer_path = [bundle pathForResource:setting.https_cer_server ofType:nil];
        } else {
            sever_cer_path = [bundle pathForResource:setting.https_cer_server ofType:@"cer"];
        }
        if ([fileManager fileExistsAtPath:sever_cer_path]) {
            manager.securityPolicy = [self yb_securityPolicy:sever_cer_path];
            if ([setting.https_p12_client hasSuffix:@".p12"]) {
                client_p12_path = [bundle pathForResource:setting.https_p12_client ofType:nil];
            } else {
                client_p12_path = [bundle pathForResource:setting.https_p12_client ofType:@"p12"];
            }
            if ([fileManager fileExistsAtPath:client_p12_path]) {
                if (setting.isTwoWayAuth) {
                    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                    [manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
                        NSLog(@"setSessionDidBecomeInvalidBlock");
                    }];
                    YB_WS(ws);
                    __weak __typeof(&*manager) mgr = manager;
                    [mgr setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * session, NSURLAuthenticationChallenge * challenge, NSURLCredential * __autoreleasing * _credential) {
                        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                        __autoreleasing NSURLCredential * credential = nil;
                        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                            if([mgr.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                                if(credential) {
                                    disposition = NSURLSessionAuthChallengeUseCredential;
                                } else {
                                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                                }
                            } else {
                                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                            }
                        } else {
                            SecIdentityRef identity = NULL;
                            SecTrustRef trust = NULL;
                            if([fileManager fileExistsAtPath:client_p12_path]) {
                                NSData * PKCS12Data = [NSData dataWithContentsOfFile:client_p12_path];
                                if ([[ws class] extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data httpsSetting:setting]) {
                                    SecCertificateRef certificate = NULL;
                                    SecIdentityCopyCertificate(identity, &certificate);
                                    const void * certs[] = {certificate};
                                    CFArrayRef certArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
                                    credential = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                                    disposition = NSURLSessionAuthChallengeUseCredential;
                                }
                            } else {
                                NSLog(@"客户端p12证书(%@)不存在，双向验证失败", setting.https_p12_client);
                            }
                        }
                        *_credential = credential;
                        return disposition;
                    }];
                } else {
                    manager.securityPolicy.validatesDomainName = YES;
                }
            } else {
                manager.securityPolicy.validatesDomainName = YES;
                NSLog(@"客户端p12证书(%@)不存在，将使用单向验证", setting.https_p12_client);
            }
        } else {
            NSLog(@"服务端cer证书(%@)不存在，不验证HTTPS，可能会取不到数据!", setting.https_cer_server);
            manager = [self httpsNotAuth:manager];
        }
    } else {
        NSLog(@"没有传递服务端cer证书，不验证HTTPS，可能会取不到数据!");
        manager = [self httpsNotAuth:manager];
    }
    return manager;
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data httpsSetting:(HttpsSetting *)setting
{
    OSStatus securityError = errSecSuccess;
    if (!setting.https_p12_client_psw.length) {NSLog(@"未设置客户端p12证书密码!"); return NO;}
    NSDictionary * optionsDict = @{(__bridge id)kSecImportExportPassphrase:setting.https_p12_client_psw};
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDict,&items);
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items,0);
        const void * tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void * tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        return NO;
    }
    return YES;
}

+ (AFSecurityPolicy *)yb_securityPolicy:(NSString *)server_cer_path
{
    NSData * certData = [NSData dataWithContentsOfFile:server_cer_path];
    NSSet * certSet = [NSSet setWithObject:certData];
    AFSecurityPolicy * policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    return policy;
}
@end
