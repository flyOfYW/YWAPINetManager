//
//  YWTestManager.m
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/6/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWTestManager.h"

@implementation YWTestManager

- (NSString *)urlString{
    return @"https://route.showapi.com/255-1?showapi_appid=45178&showapi_sign=1bc67a7c980a4a5d86f1f0d9424a023e&type=";
}
- (YWAPIManagerRequestMethod)requestMethod{
   return YWAPIManagerRequestMethodGet;
}
- (void)dealloc{
    NSLog(@"---");
}
@end
