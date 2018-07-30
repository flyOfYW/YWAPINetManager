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
/**
 生成NSURLRequest的对象(POST-raw方式)-其实本质就是AFJSONRequestSerializer
 ** - 其实内部的AF也是做了处理，self.requestSerializer应该是AFJSONRequestSerializer的对象，才会触发其先序列化原始请求对象并设置请求参数，这里我不设置AFJSONRequestSerializer其对象了，我直接设置序列化并设置body了
 @param params 参数
 @param urlString url地址
 @param requestMethod 请求表达式
 @return NSURLRequest的对象
 */
- (NSURLRequest *)requestWithBodyParams:(id)params urlString:(NSString *)urlString requestMethod:(YWAPIManagerRequestMethod)requestMethod;

@end

