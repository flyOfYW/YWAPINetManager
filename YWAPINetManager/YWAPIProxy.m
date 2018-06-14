//
//  YWAPIProxy.m
//  YKX1.0
//
//  Created by yaowei on 2018/3/28.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "YWAPIProxy.h"

@interface YWAPIProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation YWAPIProxy

static YWAPIProxy *singletonInstance = nil;

/**
 * 严谨单例的写法
 */
+ (instancetype)YWAPIProxySingletonInstance{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singletonInstance = [[self alloc] init];
    });
    return singletonInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singletonInstance = [super allocWithZone:zone];
    });
    return singletonInstance;
}
- (id)copyWithZone:(struct _NSZone *)zone{
    return singletonInstance;
}

/**
 发起网络请求 (后期AF跨了后，直接在这里替换网络请求框架)

 @param request NSURLRequest对象
 @param success 请求成功的回调
 @param fail 请求失败的回调
 @return 网络请求任务的id
 */
- (NSNumber *)sendWithRequest:(NSURLRequest *)request
                 successBlock:(YWAPIProxyCallBlock)success
                    failBlock:(YWAPIProxyCallBlock)fail{
    
    __weak typeof(self)weakSelf = self;
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    NSLog(@"******************** 请求参数 ***************************\n");
    
    NSLog(@"请求头信息: %@\n",request.allHTTPHeaderFields);
    
    NSLog(@"-------------------- 请求网址 ---------------------------\n");
    NSLog(@"请求网址: %@\n", request.URL);
   
    NSLog(@"******************** 结束 ***************************\n");

    
   dataTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
        NSNumber *requestID = @([dataTask taskIdentifier]);
       
        [weakSelf.dispatchTable removeObjectForKey:requestID];
       
       YWURLResponse *ywResponse = [[YWURLResponse alloc] initWithResponseObject:responseObject requestId:requestID request:request error:error];
       if (error) {
           fail?fail(ywResponse):nil;
       } else {
           success?success(ywResponse):nil;
       }
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    
    self.dispatchTable[requestId] = dataTask;
    
    [dataTask resume];
    
    return requestId;
}


- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}
- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (AFHTTPSessionManager *)sessionManager {
    
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = nil;
        _sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    
    
    return _sessionManager;
}
- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
