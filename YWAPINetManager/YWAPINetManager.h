//
//  YWAPINetManager.h
//  YKX1.0
//
//  Created by yaowei on 2018/3/23.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWURLResponse.h"

typedef enum : NSUInteger {
    YWAPIBaseManagerCallTypeDelegate,
    YWAPIBaseManagerCallTypeBlock,
} YWAPIBaseManagerCallType;


@interface YWAPINetManager : NSObject<NSCopying>

/** ⚠️网络请求成功或者失败时，以什么样的形式通知界面,默认YWAPIBaseManagerCallTypeDelegate，请实现协议回调，以类方法调用网络请求时，是YWAPIBaseManagerCallTypeBlock回调 */
@property (nonatomic, assign,) YWAPIBaseManagerCallType callType;

/** 里面会调用到NSObject的方法，所以这里不用id */
@property (nonatomic,   weak) NSObject<YWNetworkingProtocol> * _Nullable child;
/** ⚠️请求参数委托协议(必须设置代理) */
@property (nonatomic,   weak) id<YWNetworkingParamDataSource> _Nullable paramSource;
/** 请求头委托协议 */
@property (nonatomic,   weak) id<HTTPRequestSerializerDelagate> _Nullable requestSerializerDelegate;
/** response) */
@property (nonatomic,   weak) id<YWNetworkingCallProtocol> _Nullable delegate;
/** response */
@property (nonatomic, strong) YWURLResponse * _Nonnull response;

/** 是否正在加载数据 */
@property (nonatomic, assign, readonly) BOOL isLoading;

/** v0.0.4新增容错处理，兼容之前的版本 */
@property (nonatomic,   strong) NSObject<YWNetworkingConnectProtocol> * _Nullable errConnectManager;

- (instancetype _Nullable )initWithConnectErrManager:(id <YWNetworkingConnectProtocol>)errManager;
/**
 类方法调用网络请求
 
 @param params 参数
 @param successCallback 成功回调
 @param failCallback 失败的回调
 @return 网络请求任务id
 */
+ (NSInteger)loadDataWithParams:(nullable id)params success:(void (^_Nullable)(YWAPINetManager *_Nullable))successCallback fail:(void (^_Nullable)(YWAPINetManager *_Nullable))failCallback;
/**
 对象方法调用网络请求
 
 @return 网络请求任务id
 */
- (NSInteger)sendOnLoadData;

/**
 对象方法调用网络请求(专门解决POST-RAW传输参数)

 @return 网络请求任务id
 */
- (NSInteger)sendOnLoadDataByParamOnBody;
/**
 取消当前对象所管理的所有任务的请求
 */
- (void)cancelAllRequests;
/**
 取消当前对象所管理的单个任务的请求

 @param requestID 任务ID
 */
- (void)cancelRequestWithRequestId:(NSNumber *_Nullable)requestID;
@end



