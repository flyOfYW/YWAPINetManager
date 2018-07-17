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
    return _getUrl;
}
- (YWAPIManagerRequestMethod)requestMethod{
   return YWAPIManagerRequestMethodGet;
}
- (void)dealloc{
    NSLog(@"---");
}
@end
