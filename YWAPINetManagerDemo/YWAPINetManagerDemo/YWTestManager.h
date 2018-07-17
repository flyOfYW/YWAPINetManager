//
//  YWTestManager.h
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/6/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWAPINetManager.h"

@interface YWTestManager : YWAPINetManager <YWNetworkingProtocol>
@property (nonatomic, copy) NSString *getUrl;
@end
