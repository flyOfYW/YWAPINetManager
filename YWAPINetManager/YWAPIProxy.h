//
//  YWAPIProxy.h
//  YKX1.0
//
//  Created by yaowei on 2018/3/28.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWURLResponse.h"

typedef void(^YWAPIProxyCallBlock)(YWURLResponse *response);

@interface YWAPIProxy : NSObject
/**
 * 严谨单例的写法
 */
+ (instancetype)YWAPIProxySingletonInstance;
/**
 发起网络请求
 
 @param request NSURLRequest对象
 @param success 请求成功的回调
 @param fail 请求失败的回调
 @return 网络请求任务的id
 */
- (NSNumber *)sendWithRequest:(NSURLRequest *)request
                 successBlock:(YWAPIProxyCallBlock)success
                    failBlock:(YWAPIProxyCallBlock)fail;

/**
 取消数组里面的taskID的任务请求

 @param requestIDList taskID数组
 */
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

/**
 取消单个taskID

 @param requestID 单个taskID
 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
@end
