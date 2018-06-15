# YWAPINetManager
基于AFNetworking的高阶网络请求管理器

## 简介
是一套基于[AFNetworking 3.1.0](https://github.com/AFNetworking/AFNetworking)封装的网络库，提供了更高层次的抽象和更方便的调用方式。
## 环境要求

该库需运行在 iOS 8.0 和 Xcode 7.0以上环境.

## 集成方法

YWAPINetManager 可以在[CocoaPods](http://cocoapods.org)中获取，将以下内容添加进你的Podfile中后，运行`pod install`即可安装:

```ruby
pod 'YWAPINetManager'
```
## 特性
- 提供支持集约型API调用方式和离散型API调用方式
- 提供大多数网络访问方式和相应的序列化类型
- 提供简洁的请求参数设置
- 提供修改请求头和移除请求头
- 提供api请求结果映射接口，可以自行转换为相应的数据格式
- 支持请求前避免重复请求检测，避免不必要的请求
- 方便管理每个网络请求API
- 网络层上部分使用离散型设计，下部分使用集约型设计
- 设计合理的继承机制，让派生出来的YWAPIBaseManager受到限制，避免混乱

## 使用
- **1**：继承YWAPINetManager，并遵守协议YWNetworkingProtocol

    - **示列**：
        
            @interface YWTestManager : YWAPINetManager <YWNetworkingProtocol>

            @end
        
- **2**：设置地址和请求方式

    - **示列**：
    
            @implementation YWTestManager
            
            - (NSString *)urlString{
            return @"https://route.showapi.com/255-1?showapi_appid=45178&showapi_sign=1bc67a7c980a4a5d86f1f0d9424a023e&type=";
            }
            - (YWAPIManagerRequestMethod)requestMethod{
            return YWAPIManagerRequestMethodGet;
            }
        
    
- **3.1**：发送请求和delegate回调(方式一)

        _manager = [YWTestManager new];
        _manager.paramSource = self;
        _manager.delegate = self;
        [_manager sendOnLoadData];

        //设置参数
        - (NSDictionary *)paramsForApi:(YWAPINetManager *)manager{

        return nil;

        }
        //失败回调
        - (void)networkingCallAPIDidFailed:(YWAPINetManager *)manager{
        
        NSLog(@"错误-------\n%@",manager.response.errorMessage);
        
        }
        //成功回调
        - (void)networkingCallAPIDidSuccess:(YWAPINetManager *)manager{
        
        NSLog(@"成功---------\n%@",manager.response.content);
        }
        
- **3.2**：发送请求和block回调(方式二)

        [YWTestManager loadDataWithParams:nil success:^(YWAPINetManager * _Nullable manager) {

            } fail:^(YWAPINetManager * _Nullable manager) {

        }];


更多详细使用，请查看[demo](https://codeload.github.com/flyOfYW/YWAPINetManager/zip/master)




