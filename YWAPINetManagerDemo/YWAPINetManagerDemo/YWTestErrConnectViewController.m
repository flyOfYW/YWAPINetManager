//
//  YWTestErrConnectViewController.m
//  YWAPINetManagerDemo
//
//  Created by yaowei on 2018/7/17.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWTestErrConnectViewController.h"
#import "YWTestManager.h"
#import "YWConnectErrManager.h"

@interface YWTestErrConnectViewController ()<YWNetworkingParamDataSource,YWNetworkingCallProtocol>

@property (nonatomic, weak) UILabel *menuLabel;
@property (nonatomic, strong) YWTestManager *manager;

@end

@implementation YWTestErrConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.manager sendOnLoadData];

    UILabel *la = ({
        la = [UILabel new];
        la.frame = CGRectMake(10, 100, 300, 30);
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
    
    if (manager.response.code == 200) {
        _menuLabel.text = [NSString stringWithFormat:@"%@",@"请求成功"];
    }else{
        _menuLabel.text = [NSString stringWithFormat:@"%@",manager.response.content[@"message"]];
        NSLog(@"----%@",manager.response.content);
    }
}
//设置参数
- (NSDictionary *)paramsForApi:(YWAPINetManager *)manager{
    
    return nil;
    
}
- (YWTestManager *)manager{
    if (!_manager) {
        YWConnectErrManager *err = [[YWConnectErrManager alloc] init];
        _manager = [[YWTestManager alloc] initWithConnectErrManager:err];
        _manager.paramSource = self;
        _manager.delegate = self;
        _manager.getUrl = @"https://www.sojson.com/open/api/weather/json.shtml?city=广州";
        _manager.method = YWAPIManagerRequestMethodGet;
    }
    return _manager;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
