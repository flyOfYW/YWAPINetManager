//
//  YWNetworkingProtocol.h
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/6/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWAPINetManager;


typedef NS_ENUM(NSUInteger, YWURLResponseStatus)
{
    YWURLResponseStatusSuccess = 0, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的YWAPINetManager来决定。
    YWURLResponseStatusErrorTimeout,// 取消请求超时
    YWURLResponseStatusErrorCancel,// 取消请求任务
    YWURLResponseStatusErrorNoNetwork, // 无网络错误
    YWURLResponseStatusErrorNetworkConnectionLost, // 当有错误时：默认网络连接异常
    YWURLResponseStatusErrorCannotFindHost,//找不到服务器
    YWURLResponseStatusErrorCannotConnectToHost,//连接不上服务器
    YWURLResponseStatusErrorResourceUnavailable,//资源不可用
    //以下根据自身需求扩展
    YWURLResponseStatusErrorNeedAccessToken,//token失效
    
};
typedef enum : NSUInteger {
    YWAPIManagerRequestMethodGet = 0,
    YWAPIManagerRequestMethodPut,
    YWAPIManagerRequestMethodPost,
    YWAPIManagerRequestMethodDelete,
} YWAPIManagerRequestMethod;


@protocol YWNetworkingProtocol <NSObject>

@required
/**
 url
 
 @return 接口地址
 */
- (NSString *_Nullable)urlString;
/**
 请求方式
 
 @return 请求方式
 */
- (YWAPIManagerRequestMethod)requestMethod;

@end

@protocol YWNetworkingCallProtocol <NSObject>
@optional
/**
 网络请求成功
 
 @param manager YWNetResponse对象
 */
- (void)networkingCallAPIDidSuccess:(YWAPINetManager * _Nonnull)manager;
/**
 网络请求失败
 
 @param manager YWNetResponse对象
 */
- (void)networkingCallAPIDidFailed:(YWAPINetManager * _Nonnull)manager;
@end

//参数数据源协议
@protocol YWNetworkingParamDataSource <NSObject>
@required
- (NSDictionary *_Nullable)paramsForApi:(YWAPINetManager *_Nonnull)manager;

@end
//设置请求头参数的协议
@protocol HTTPRequestSerializerDelagate <NSObject>
@optional

/**(常用请求头：@"User-Agen",@"Accept",@"Authorization")
 设置请求头(key-Value形式传入；如：@{@"User-Agen":@"value1"})
 
 @return 请求头
 */
- (NSDictionary *_Nullable)HTTPRequestSerializerForApi;
///**
// 移除请求头（请求头的数组如：@[@"User-Agen",@"Accept"]）
//
// @return 请求头数组
// */
//- (NSArray *_Nullable)clearHTTPRequestSerializerForApi;

@end
