//
//  YWBaseService.m
//  YKX1.0
//
//  Created by yaowei on 2018/3/28.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWBaseService.h"

@interface YWBaseService ()

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

@end

@implementation YWBaseService

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

/**
 生成NSURLRequest的对象
 
 @param params 参数
 @param urlString url地址
 @param requestMethod 请求表达式
 @return NSURLRequest的对象
 */
- (NSURLRequest *)requestWithParams:(id)params urlString:(NSString *)urlString requestMethod:(YWAPIManagerRequestMethod)requestMethod {
    
    NSString * method = @"GET";
    
    switch (requestMethod) {
        case YWAPIManagerRequestMethodGet:
            method = @"GET";
            break;
        case YWAPIManagerRequestMethodPost:
            method = @"POST";
            break;
        case YWAPIManagerRequestMethodPut:
            method = @"PUT";
            break;
        case YWAPIManagerRequestMethodDelete:
            method = @"DELETE";
            break;
        default:
            break;
    }

    NSError *serializationError = nil;

    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:params error:&serializationError];
    
    if (serializationError) {
        NSLog(@"不能初始化request");
        return nil;
    }
    return request;
    
}

/**
 生成NSURLRequest的对象(POST-raw方式)-其实本质就是AFJSONRequestSerializer
 ** - 其实内部的AF也是做了处理，self.requestSerializer应该是AFJSONRequestSerializer的对象，才会触发其先序列化原始请求对象并设置请求参数，这里我不设置AFJSONRequestSerializer其对象了，我直接设置序列化并设置body了
 @param params 参数
 @param urlString url地址
 @param requestMethod 请求表达式
 @return NSURLRequest的对象
 */
- (NSURLRequest *)requestWithBodyParams:(id)params urlString:(NSString *)urlString requestMethod:(YWAPIManagerRequestMethod)requestMethod{
    
    NSString * method = @"GET";
    
    switch (requestMethod) {
        case YWAPIManagerRequestMethodGet:
            method = @"GET";
            break;
        case YWAPIManagerRequestMethodPost:
            method = @"POST";
            break;
        case YWAPIManagerRequestMethodPut:
            method = @"PUT";
            break;
        case YWAPIManagerRequestMethodDelete:
            method = @"DELETE";
            break;
        default:
            break;
    }
    
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil error:&serializationError];
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    // 设置body
    [request setHTTPBody:body];
    
    if (serializationError) {
        NSLog(@"不能初始化request");
        return nil;
    }
    
    return request;
}
- (AFHTTPRequestSerializer *)httpRequestSerializer{
    
    return self.requestSerializer;
    
}

- (AFHTTPRequestSerializer *)requestSerializer{
    if (!_requestSerializer) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _requestSerializer;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
