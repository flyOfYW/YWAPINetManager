//
//  YWTestViewController.m
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/6/14.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWTestViewController.h"
#import "YWTestManager.h"


@interface YWTestViewController ()<YWNetworkingParamDataSource,YWNetworkingCallProtocol>

@property (nonatomic, weak) UILabel *menuLabel;
@property (nonatomic, strong) YWTestManager *manager;
@end

@implementation YWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.manager sendOnLoadData];
    
  //方式二
//    [YWTestManager loadDataWithParams:@{} success:^(YWAPINetManager * _Nullable manager) {
//
//    } fail:^(YWAPINetManager * _Nullable manager) {
//
//    }];
    
    UILabel *la = ({
        la = [UILabel new];
        la.frame = CGRectMake(100, 100, 100, 30);
        [self.view addSubview:la];
        _menuLabel = la;
        la;
    });
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
    
    return nil;
    
}

- (YWTestManager *)manager{
    if (!_manager) {
        _manager = [YWTestManager new];
        _manager.paramSource = self;
        _manager.delegate = self;
        _manager.getUrl = @"https://route.showapi.com/255-1?showapi_appid=45178&showapi_sign=1bc67a7c980a4a5d86f1f0d9424a023e&type=";
        _manager.method = YWAPIManagerRequestMethodGet;
    }
    return _manager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

