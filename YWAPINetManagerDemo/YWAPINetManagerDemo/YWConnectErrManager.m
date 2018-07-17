//
//  YWConnectErrManager.m
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/7/16.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWConnectErrManager.h"
#import "YWURLResponse.h"

@implementation YWConnectErrManager
- (id)networkingDidFailedDealWith:(YWURLResponse *)response withRespone:(NSURLResponse *)urlResponse{
    return nil;
}
- (id)networkingDidSuccessDealWith:(YWURLResponse *)response withRespone:(NSURLResponse *)urlResponse{
    if (response.status == YWURLResponseStatusSuccess) {
        NSDictionary *content = response.content;

        //可以使用公开的code作为自身服务器代表的成功和失败的状态
        response.code = [content[@"status"] integerValue];
        if (response.code != 200) {
            NSLog(@"----********-----%@",content);
            NSLog(@"----********-----\n");
            return content;
        }else{
            return content[@"data"];
        }
    }
    return nil;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
