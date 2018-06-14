//
//  YWURLResponse.m
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/6/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWURLResponse.h"

@interface YWURLResponse ()

@property (nonatomic, assign, readwrite) YWURLResponseStatus status;
@property (nonatomic, copy,   readwrite) id content;
@property (nonatomic, copy,   readwrite) NSURLRequest *request;
@property (nonatomic, strong, readwrite) NSNumber *requestId;
@property (nonatomic, copy,   readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) NSString *errorMessage;
@property (nonatomic, assign, readwrite) int code;
/** 将网络请求返回的NSError的错误代码代表的信息转译中文信息 */
@property (nonatomic, strong, readwrite) NSString *errorDetailMsg;


@end

@implementation YWURLResponse
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
                                 error:(NSError *)error{
    self = [super init];
    if (self) {
        _requestId = requestId;
        _request = request;
        _status = [self conversionStatusWithError:error];
        _responseData = responseObject;
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
            _code = 0;
            _content = dict;
            //个人项目返回了status，根据需求进行修改
//            _code = [[dict objectForKey:@"status"] intValue];
//            _content = [dict objectForKey:@"content"];
        }else{
            _code = - 1012;
            _content = @"返回的对象为nil";
        }
    }
    return self;
}
- (YWURLResponseStatus)conversionStatusWithError:(NSError *)error{
    if (error) {
        YWURLResponseStatus result = YWURLResponseStatusErrorNetworkConnectionLost;
        
        if (error.code == NSURLErrorTimedOut) {
            result = YWURLResponseStatusErrorTimeout;
            _errorDetailMsg = @"请求超时";
        }
        if (error.code == NSURLErrorCancelled) {
            result = YWURLResponseStatusErrorCancel;
            _errorDetailMsg = @"您已经取消请求";
        }
        if (error.code == NSURLErrorNotConnectedToInternet) {
            result = YWURLResponseStatusErrorNoNetwork;
            _errorDetailMsg = @"无网络错误";
        }
        if (error.code == NSURLErrorCannotFindHost) {
            result = YWURLResponseStatusErrorCannotFindHost;
            _errorDetailMsg = @"找不到服务器";
        }
        if (error.code == NSURLErrorResourceUnavailable) {
            result = YWURLResponseStatusErrorResourceUnavailable;
            _errorDetailMsg = @"资源不可用";
        }
        if (error.code == NSURLErrorCannotConnectToHost) {
            result = YWURLResponseStatusErrorCannotConnectToHost;
            _errorDetailMsg = @"连接不上服务器";
        }
        _errorMessage = [NSString stringWithFormat:@"%@", error];

        return result;
    } else {
        return YWURLResponseStatusSuccess;
    }
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
