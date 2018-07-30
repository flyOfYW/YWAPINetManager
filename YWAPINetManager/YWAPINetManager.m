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

- (instancetype)initWithConnectErrManager:(id<YWNetworkingConnectProtocol>)errManager{
    self = [super init];
    if (self) {
        _delegate = nil;
        _callType = YWAPIBaseManagerCallTypeDelegate;
        if ([errManager conformsToProtocol:@protocol(YWNetworkingConnectProtocol)]) {
            self.errConnectManager = errManager;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
        if ([self conformsToProtocol:@protocol(YWNetworkingProtocol)]) {
            self.child = (id <YWNetworkingProtocol>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    return self;
}
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
    return [self loadDataWithParams:params isBodyParam:NO];
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
    NSInteger requestId = [self loadDataWithParams:params isBodyParam:NO];
    return requestId;
}
/**
 对象方法调用网络请求(专门解决POST-RAW传输参数)
 
 @return 网络请求任务id
 */
- (NSInteger)sendOnLoadDataByParamOnBody{
    if (!self.paramSource) {
        NSLog(@"self.paramSource不存在");
    }
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params isBodyParam:YES];
    return requestId;
}
- (NSInteger)loadDataWithParams:(NSDictionary *)params isBodyParam:(BOOL)isBody{

    //设置正在加载
    self.isLoading = YES;
    
//    YWBaseService -- requestSerializer修改请求头
    id<YWServiceProtocol>serviceProtocol = [[YWServiceFactory singletonInstance] serviceWithIdentifier:self.child.urlString];
    
    if ([self.requestSerializerDelegate respondsToSelector:@selector(HTTPRequestSerializerForApi)]) {
        NSDictionary *dict = [self.requestSerializerDelegate HTTPRequestSerializerForApi];
        for (NSString *key in dict.allKeys) {
            [[serviceProtocol httpRequestSerializer] setValue:dict[key] forHTTPHeaderField:key];
        }
    }
    NSURLRequest *request;
    if (isBody) {
        request = [serviceProtocol requestWithBodyParams:params urlString:self.child.urlString requestMethod:self.child.requestMethod];
    }else{
        request = [serviceProtocol requestWithParams:params urlString:self.child.urlString requestMethod:self.child.requestMethod];
    }
    
    __weak typeof(self)weakSelf = self;
    
   NSNumber *requestId = [[YWAPIProxy YWAPIProxySingletonInstance] sendWithRequest:request successBlock:^(YWURLResponse *response, NSURLResponse *urlResponse) {
        [weakSelf successedHandle:response withRespone:urlResponse];
    } failBlock:^(YWURLResponse *response, NSURLResponse *urlResponse) {
        [weakSelf failedHandle:response withRespone:urlResponse];
    }];
    
    [self.requestIdList addObject:requestId];
    
    return [requestId integerValue];
    
}

- (void)successedHandle:(YWURLResponse *)response withRespone:(NSURLResponse *)urlResponse{
    
    self.response = response;
    
    if (self.errConnectManager) {
       id content = [self.errConnectManager networkingDidSuccessDealWith:response withRespone:urlResponse];
        self.response = response;
        self.response.content = content;
    }
    self.isLoading = NO;

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

- (void)failedHandle:(YWURLResponse *)response withRespone:(NSURLResponse *)urlResponse{
    
    self.isLoading = NO;
    if (response) {
        self.response = response;
    }
    if (self.errConnectManager) {
     [self.errConnectManager networkingDidFailedDealWith:response withRespone:urlResponse];
    }
    
    [self removeRequestIdWithRequestID:response.requestId];
    
    
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
