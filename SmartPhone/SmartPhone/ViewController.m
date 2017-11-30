//
//  ViewController.m
//  SmartPhone
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "UDPManage.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
@property (strong, nonatomic)UILabel *showLog;
@property (strong, nonatomic)UIButton *btnSend;

@end
int count;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"打开app");
    self.showLog.text = @"打开app";
    self.btnSend.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UDPManage shareUDPManage]receiveBlock:^(NSString *ip, uint16_t port, NSString *mes) {
        
        NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, mes);
        [self appendStr:mes];
    }];
}

- (void)appendStr:(NSString *)str
{
    
    self.showLog.text = [NSString stringWithFormat:@"%@ \n%@",self.showLog.text,str];
}
- (void)send
{
    count ++;
    [[UDPManage shareUDPManage]sendMessage:[NSString stringWithFormat:@"测试：%d",count]];
}

- (UILabel *)showLog
{
    if (!_showLog) {
        _showLog = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100)];
        _showLog.textAlignment = NSTextAlignmentCenter;
        _showLog.numberOfLines = 0;
        [self.view addSubview:_showLog];
    }
    return _showLog;
}

- (UIButton *)btnSend
{
    if (!_btnSend) {
        _btnSend = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2- 200/2, 20, 200, 60)];
        [_btnSend addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        _btnSend.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_btnSend];
    }
    return _btnSend;
}

@end
