//
//  YWNetworkingProtocol.h
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/6/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YWAPINetManager;
@class YWURLResponse;

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

/**
 * 进行容错处理协议
 * 业务场景：
 * 如：1、登录token失效，在遵守该协议的类统一处理登录事件或者刷新token
 *    2、后台进行error的处理，返回给手机端code或者status代表成功和失败，因此也可以进行统一事件处理
 */
@protocol YWNetworkingConnectProtocol <NSObject>
@required
/**
 处理网络请求成功的数据（如处理后台返回的code或者status的某个值作为请求请求成功的代表,因此YWURLResponse特意开放code属性给外界，以便接收后台返回的状态）
 response.status==YWURLResponseStatusSuccess//作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的YWAPINetManager来决定。
 因此,实现该方法，可以统一处理数据是否完整性，从而剥离每个上层的YWAPINetManager来处理
 @param response 网络请求成功后的数据对象
 @param urlResponse 网络请求本身block的response，可以选择性处理
 @return 返回response.content的值（必须返回），
 */
- (id _Nullable )networkingDidSuccessDealWith:(YWURLResponse *_Nullable)response withRespone:(NSURLResponse *_Nullable)urlResponse;
/**
 处理网络请求失败的数据（如处理NSURLResponse的状态（statusCode））
 之前我在一家公司，遇到一个比较奇葩的处理 ：NSHTTPURLResponse *ta = (NSHTTPURLResponse *)urlResponse; if (ta.statusCode == 401) {//刷新token}，要去取NSURLResponse里的状态判断token是否失效，后台没有对异常信息处理，因此该方法针对特殊情况处理
 因此,实现该方法，可以统一处理数据是否完整性，从而剥离每个上层的YWAPINetManager来处理
 @param response 网络请求失败后的数据对象
 @param urlResponse 网络请求本身block的response，可以选择性处理
 @return 返回nil(暂时未使用到改值)
 */
- (id _Nullable )networkingDidFailedDealWith:(YWURLResponse *_Nullable)response withRespone:(NSURLResponse *_Nullable)urlResponse;

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
- (nullable id)paramsForApi:(YWAPINetManager *_Nonnull)manager;

@end
//设置请求头参数的协议
@protocol HTTPRequestSerializerDelagate <NSObject>
@optional

/**(常用请求头：@"User-Agen",@"Accept",@"Authorization")
 设置请求头(key-Value形式传入；如：@{@"User-Agen":@"value1"})
 
 @return 请求头
 */
- (NSDictionary *_Nullable)HTTPRequestSerializerForApi;

- (NSDictionary *_Nullable)requestSerializerForApi:(YWAPINetManager *_Nonnull)manager;
///**
// 移除请求头（请求头的数组如：@[@"User-Agen",@"Accept"]）
//
// @return 请求头数组
// */
//- (NSArray *_Nullable)clearHTTPRequestSerializerForApi;

@end
