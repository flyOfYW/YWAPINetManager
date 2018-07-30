//
//  YWPostBodyViewController.m
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/7/30.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWPostBodyViewController.h"
#import "YWTestManager.h"

@interface YWPostBodyViewController ()<YWNetworkingParamDataSource,YWNetworkingCallProtocol,HTTPRequestSerializerDelagate>

@property (nonatomic, strong) YWTestManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;

@end

@implementation YWPostBodyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager sendOnLoadDataByParamOnBody];
    //该接口可能失效token了
}
//失败回调
- (void)networkingCallAPIDidFailed:(YWAPINetManager *)manager{
    
    NSLog(@"错误-------\n%@",manager.response.errorMessage);
    
    _menuLabel.text = manager.response.errorMessage;
}
//成功回调
- (void)networkingCallAPIDidSuccess:(YWAPINetManager *)manager{
    
    NSLog(@"成功---------\n%@",manager.response.content);
    _menuLabel.text = [NSString stringWithFormat:@"%@",@"成功"];
    
}
//设置参数
- (NSDictionary *)paramsForApi:(YWAPINetManager *)manager{
    
    return @{@"summary":@"1231"};
    
}
- (NSDictionary *)HTTPRequestSerializerForApi{
    return @{@"Content-Type":@"application/json;charset=UTF-8"};//@"text/xml; charset=utf-8
}
- (YWTestManager *)manager{
    if (!_manager) {
        _manager = [YWTestManager new];
        _manager.paramSource = self;
        _manager.delegate = self;
        _manager.requestSerializerDelegate = self;
        _manager.getUrl = @"http://106.75.165.4:8811/user/modify?id=5&session_id=8702b1bee3bd4e25a6f7d3e1c1cfb8c4";
        _manager.method = YWAPIManagerRequestMethodPost;
    }
    return _manager;
}

@end
