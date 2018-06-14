//
//  YWServiceProtocol.h
//  YKX1.0
//
//  Created by yaowei on 2018/3/28.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "YWNetworkingProtocol.h"

@protocol YWServiceProtocol <NSObject>
- (AFHTTPRequestSerializer *)httpRequestSerializer;
/**
 生成NSURLRequest的对象

 @param params 参数
 @param urlString url地址
 @param requestMethod 请求表达式
 @return NSURLRequest的对象
 */
- (NSURLRequest *)requestWithParams:(id)params
                                   urlString:(NSString *)urlString
                      requestMethod:(YWAPIManagerRequestMethod)requestMethod;

@end

