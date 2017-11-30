//
//  ViewController.m
//  SmartPhone
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "ViewController.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#import "AsyncUdpSocket.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface ViewController ()
@property (strong, nonatomic)UILabel *showLog;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"打开app");
    self.showLog.text = @"打开app";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        [self UDP_Server];
//    });
    
    AsyncUdpSocket *asyncUdpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self]; //2.1.3.绑定端口
    NSError *err = nil;
    [asyncUdpSocket enableBroadcast:YES error:&err];
    [asyncUdpSocket bindToPort:9527 error:&err];   //启动接收线程
    [asyncUdpSocket receiveWithTimeout:-1 tag:0];  //2.1.4.实现代理方法
    
}


//已接收到消息
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
//    if(data是找服务器的){
//        //根据客户端给的IP，利用TCP或UDP 相互连接上就可以开始通讯了
//
//    }
    return YES;
    
}
//没有接受到消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    
} //没有发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
} //已发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
} //断开连接
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    
}


- (void)appendStr:(NSString *)str
{
    self.showLog.text = [NSString stringWithFormat:@"%@ \n%@",self.showLog.text,str];
}

/*
 第一步：创建socket并配置socket
 第二步：调用bind绑定服务器本机ip及端口号
 第三步：调用recvfrom接收来自客户端的消息
 第四步：调用sendto将接收到服务器端的信息返回给客户端
 第四步：调用close关闭socket
 */
-(void)UDP_Server
{
    int serverSockerId = -1;
    ssize_t len = -1;
    socklen_t addrlen;
    char buff[1024];
    struct sockaddr_in ser_addr;
    
    // 第一步：创建socket
    // 注意，第二个参数是SOCK_DGRAM，因为udp是数据报格式的
    serverSockerId = socket(AF_INET, SOCK_DGRAM, 0);
    
    if(serverSockerId < 0) {
        NSLog(@"Create server socket fail");
        [self appendStr:@"Create server socket fail" ];
        return;
    }
    
    addrlen = sizeof(struct sockaddr_in);
    bzero(&ser_addr, addrlen);
    
    ser_addr.sin_family = AF_INET;
    ser_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    ser_addr.sin_port = htons(1112);
    
    // 第二步：绑定端口号
    if(bind(serverSockerId, (struct sockaddr *)&ser_addr, addrlen) < 0) {
        NSLog(@"server connect socket fail");
        [self appendStr:@"server connect socket fail"];
        return;
    }
    
    for (; ; ) {
        bzero(buff, sizeof(buff));
        
        // 第三步：接收客户端的消息
        len = recvfrom(serverSockerId, buff, sizeof(buff), 0, (struct sockaddr *)&ser_addr, &addrlen);
        // 显示client端的网络地址
        NSLog(@"receive from %s\n", inet_ntoa(ser_addr.sin_addr));
        // 显示客户端发来的字符串
        NSLog(@"recevce:%s", buff);
        
        [self appendStr:[NSString stringWithFormat:@"receive from %s\n", inet_ntoa(ser_addr.sin_addr)]];
        
        [self appendStr:[NSString stringWithFormat:@"recevce:%s", buff]];
        
        // 第四步：将接收到的客户端发来的消息，发回客户端
        // 将字串返回给client端
                sendto(serverSockerId, buff, len, 0, (struct sockaddr *)&ser_addr, addrlen);
    }
    
    
//     第五步：关闭socket
    close(serverSockerId);
    
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
@end
