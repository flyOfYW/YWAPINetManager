//
//  YWServiceFactory.h
//  YKX1.0
//
//  Created by yaowei on 2018/3/28.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWServiceProtocol.h"


#ifndef YW_INSTANCETYPE
#if __has_feature(objc_instancetype)
#define YW_INSTANCETYPE instancetype
#else
#define YW_INSTANCETYPE id
#endif
#endif

/**
 * 工厂模式管理YWBaseService和继承其的子类
 */

@interface YWServiceFactory : NSObject

/**
 通过单例获取唯一的实例化对象

 @return 对象
 */
+ (YW_INSTANCETYPE)singletonInstance;
/**
 获取遵守YWServiceProtocol的对象，（提供复用功能，可以避免重复初始化同一个对象）

 @param identifier 复用标识(⚠️：以遵守YWServiceProtocol的对象的类名作复用标识)
 @return 遵守YWServiceProtocol的对象
 */
- (id <YWServiceProtocol>)serviceWithIdentifier:(NSString *)identifier;

@end
