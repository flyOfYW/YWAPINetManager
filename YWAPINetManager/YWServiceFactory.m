//
//  YWServiceFactory.m
//  YKX1.0
//
//  Created by yaowei on 2018/3/28.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWServiceFactory.h"

@interface YWServiceFactory ()

/** 复用池 */
@property (nonatomic, strong) NSMutableDictionary *serviceReusePool;

@end


@implementation YWServiceFactory

static YWServiceFactory *singletonInstance = nil;
/**
 * 严谨单例的写法
 */
+ (YW_INSTANCETYPE)singletonInstance{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singletonInstance = [[self alloc] init];
    });
    return singletonInstance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        singletonInstance = [super allocWithZone:zone];
    });
    return singletonInstance;
}
- (id)copyWithZone:(struct _NSZone *)zone{
    return singletonInstance;
}

- (id<YWServiceProtocol>)serviceWithIdentifier:(NSString *)identifier{
    
    NSString *identifierNew = [NSString stringWithFormat:@"%@",identifier];
    //过滤中文
    NSString *encodeIden = [NSString stringWithFormat:@"%@",[self strUTF8Encoding:identifierNew]];
    
    if (!self.serviceReusePool[encodeIden]) {
        //每当缓存池有十个对象时，就清掉缓存池
        if ([self.serviceReusePool allKeys].count >=10) {
            [self.serviceReusePool removeAllObjects];
        }
        self.serviceReusePool[encodeIden] = [self initServiceWithIdentifier:@"YWBaseService"];
    }
    return self.serviceReusePool[encodeIden];
}
- (id)initServiceWithIdentifier:(NSString *)identifier{
    Class serviceClass = NSClassFromString(identifier);
    return [[serviceClass alloc] init];
}
- (NSString *)strUTF8Encoding:(NSString *)str
{
    /*! ios9适配的话 打开第一个 */
    //return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSMutableDictionary *)serviceReusePool{
    
    if (!_serviceReusePool) {
        _serviceReusePool = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _serviceReusePool;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
    
#if !__has_feature(objc_arc)
    [self.serviceReusePool release];
    [super dealloc];
#endif
    
}
@end
