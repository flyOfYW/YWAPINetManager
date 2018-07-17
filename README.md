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
- 设计统一的接口协议处理请求结果数据

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
        
          
- **3.3**：接口统一处理协议
```
/**
 * 进行容错处理协议
 * 业务场景：
 * 如：1、登录token失效，在遵守该协议的类统一处理登录事件或者刷新token
 *    2、后台进行error的处理，返回给手机端code或者status代表成功和失败，因此也可以进行统一事件处理
 */
@protocol YWNetworkingConnectProtocol <NSObject>
@required
/**
 处理网络请求成功的数据（如处理后台返回的code或者status的某个值作为请求请求成功的代表,因此YWURLResponse特意开放code属性给外界，以便接收后台返回的状态）
 response.status==YWURLResponseStatusSuccess//作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的YWAPINetManager来决定。
 因此,实现该方法，可以统一处理数据是否完整性，从而剥离每个上层的YWAPINetManager来处理
 @param response 网络请求成功后的数据对象
 @param urlResponse 网络请求本身block的response，可以选择性处理
 @return 返回response.content的值（必须返回），
 */
- (id _Nullable )networkingDidSuccessDealWith:(YWURLResponse *_Nullable)response withRespone:(NSURLResponse *_Nullable)urlResponse;
/**
 处理网络请求失败的数据（如处理NSURLResponse的状态（statusCode））
 之前我在一家公司，遇到一个比较奇葩的处理 ：NSHTTPURLResponse *ta = (NSHTTPURLResponse *)urlResponse; if (ta.statusCode == 401) {//刷新token}，要去取NSURLResponse里的状态判断token是否失效，后台没有对异常信息处理，因此该方法针对特殊情况处理
 因此,实现该方法，可以统一处理数据是否完整性，从而剥离每个上层的YWAPINetManager来处理
 @param response 网络请求失败后的数据对象
 @param urlResponse 网络请求本身block的response，可以选择性处理
 @return 返回nil(暂时未使用到改值)
 */
- (id _Nullable )networkingDidFailedDealWith:(YWURLResponse *_Nullable)response withRespone:(NSURLResponse *_Nullable)urlResponse;

@end
   ```    
  


更多详细使用，请查看[demo](https://codeload.github.com/flyOfYW/YWAPINetManager/zip/master)




