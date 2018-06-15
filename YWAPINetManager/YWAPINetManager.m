//
//  YWAPINetManager.m
//  YKX1.0
//
//  Created by yaowei on 2018/3/23.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWAPINetManager.h"
#import "YWServiceFactory.h"
#import "YWAPIProxy.h"

@interface YWAPINetManager ()

@property (nonatomic, strong) NSMutableArray * requestIdList;

/** 是否正在加载数据,防止重复请求（网络请求比较耗电，这样处理可以实现一点电量优化） */
@property (nonatomic, assign, readwrite) BOOL isLoading;

@property (nonatomic, strong, nullable) void (^successBlock)(YWAPINetManager *apimanager);
@property (nonatomic, strong, nullable) void (^failBlock)(YWAPINetManager *apimanager);
@end


@implementation YWAPINetManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        
        _callType = YWAPIBaseManagerCallTypeDelegate;
        
        if ([self conformsToProtocol:@protocol(YWNetworkingProtocol)]) {
            self.child = (id <YWNetworkingProtocol>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

/**
 类方法调用网络请求

 @param params 参数
 @param successCallback 成功回调
 @param failCallback 失败的回调
 @return 网络请求任务id
 */
+ (NSInteger)loadDataWithParams:(NSDictionary *)params success:(void (^)(YWAPINetManager *))successCallback fail:(void (^)(YWAPINetManager *))failCallback{
    return [[[self alloc] init] loadDataWithParams:params success:successCallback fail:failCallback];
}
- (NSInteger)loadDataWithParams:(NSDictionary *)params success:(void (^)(YWAPINetManager *))successCallback fail:(void (^)(YWAPINetManager *))failCallback
{
    self.successBlock = successCallback;
    self.failBlock = failCallback;
    //默认block形式
    self.callType = YWAPIBaseManagerCallTypeBlock;
    return [self loadDataWithParams:params];
}

/**
 对象方法调用网络请求

 @return 网络请求任务id
 */
- (NSInteger)sendOnLoadData{
    if (!self.paramSource) {
        NSLog(@"self.paramSource不存在");
    }
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params{

    //设置正在加载
    self.isLoading = YES;
    
//    YWBaseService -- requestSerializer修改请求头
    id<YWServiceProtocol>serviceProtocol = [[YWServiceFactory singletonInstance] serviceWithIdentifier:self.child.urlString];
    
//    if ([self.requestSerializerDelegate respondsToSelector:@selector(clearHTTPRequestSerializerForApi)]) {
//       NSArray *arr = [self.requestSerializerDelegate clearHTTPRequestSerializerForApi];
//        for (NSString *key in arr) {
//            [[serviceProtocol httpRequestSerializer] setValue:nil forHTTPHeaderField:key];
//        }
//    }
    
    if ([self.requestSerializerDelegate respondsToSelector:@selector(HTTPRequestSerializerForApi)]) {
        NSDictionary *dict = [self.requestSerializerDelegate HTTPRequestSerializerForApi];
        for (NSString *key in dict.allKeys) {
            [[serviceProtocol httpRequestSerializer] setValue:dict[key] forHTTPHeaderField:key];
        }
    }
    
    
   NSURLRequest *request = [serviceProtocol requestWithParams:params urlString:self.child.urlString requestMethod:self.child.requestMethod];
    
    __weak typeof(self)weakSelf = self;

   NSNumber *requestId = [[YWAPIProxy YWAPIProxySingletonInstance] sendWithRequest:request successBlock:^(YWURLResponse *response) {
       [weakSelf successedHandle:response];
    } failBlock:^(YWURLResponse *response) {
        [weakSelf failedHandle:response];
    }];
    
    [self.requestIdList addObject:requestId];
    
    return [requestId integerValue];
    
}

- (void)successedHandle:(YWURLResponse *)response{
    
    self.isLoading = NO;
    self.response = response;

    [self removeRequestIdWithRequestID:response.requestId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.callType == YWAPIBaseManagerCallTypeDelegate) {
            if ([self.delegate respondsToSelector:@selector(networkingCallAPIDidSuccess:)]) {
                [self.delegate networkingCallAPIDidSuccess:self];
            }
        }else{
            if (self.successBlock) {
                self.successBlock(self);
            }
        }
    });
    
}

- (void)failedHandle:(YWURLResponse *)response {
    
    self.isLoading = NO;
    if (response) {
        self.response = response;
    }
    
    [self removeRequestIdWithRequestID:response.requestId];
    
    
    // 其他错误，根据需求处理:如

//    // user token 无效，重新登录
//    if (response.status == YWURLResponseStatusErrorNeedAccessToken) {
//      //可用发通知，去跳转到登录
//
//        return;
//    }
//

    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.callType == YWAPIBaseManagerCallTypeDelegate) {
            if ([self.delegate respondsToSelector:@selector(networkingCallAPIDidFailed:)]) {
                [self.delegate networkingCallAPIDidFailed:self];
            }
        }else{
            if (self.failBlock) {
                self.failBlock(self);
            }
        }
    });
}

- (void)removeRequestIdWithRequestID:(NSNumber *)requestId{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId  isEqual: requestId]) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
- (void)cancelAllRequests{
    [[YWAPIProxy YWAPIProxySingletonInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}
- (void)cancelRequestWithRequestId:(NSNumber *)requestID{
    [[YWAPIProxy YWAPIProxySingletonInstance] cancelRequestWithRequestID:requestID];
    [self removeRequestIdWithRequestID:requestID];
}


//MARK: --- setter&getter

- (NSMutableArray *)requestIdList{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (void)dealloc{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

@end
