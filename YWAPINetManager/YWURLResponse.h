//
//  YWURLResponse.h
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/6/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWNetworkingProtocol.h"

@interface YWURLResponse : NSObject

@property (nonatomic, assign, readonly) YWURLResponseStatus status;
@property (nonatomic, copy,   readonly) id content;
@property (nonatomic, assign, readonly) int code;
@property (nonatomic, strong, readonly) NSNumber *requestId;
@property (nonatomic, copy,   readonly) NSURLRequest *request;
@property (nonatomic, copy,   readonly) NSData *responseData;
/** 将网络请求返回的NSError格式化成errorMessage */
@property (nonatomic, strong, readonly) NSString *errorMessage;
/** 将网络请求返回的NSError的错误代码代表的信息转译中文信息 */
@property (nonatomic, strong, readonly) NSString *errorDetailMsg;

/**
 初始化YWNetResponse对象
 
 @param responseObject 服务器返回的数据
 @param requestId 请求任务id
 @param request NSURLRequest对象
 @param error NSError对象
 @return YWNetResponse对象
 */
- (instancetype)initWithResponseObject:(id)responseObject
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                                 error:(NSError *)error;

@end
