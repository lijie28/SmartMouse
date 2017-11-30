

#import "UDPManage.h"
#import "GCDAsyncUdpSocket.h"
@interface UDPManage ()<GCDAsyncUdpSocketDelegate>
/** block */
@property (nonatomic, weak) ReceiveBlock receiveBlock;
@end

@implementation UDPManage
//2.创建全局变量
//这个socket用来做发送使用 当然也可以接收
GCDAsyncUdpSocket *sendUdpSocket;
//3.创建单例
static UDPManage *myUDPManage = nil;

+(instancetype)shareUDPManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myUDPManage = [[UDPManage alloc]init];
        [myUDPManage createClientUdpSocket];
    });
    return myUDPManage;
}
//4.创建socket
#pragma mark -- 创建socket
-(void)createClientUdpSocket{
    //1.创建一个 udp socket用来和服务器端进行通讯
    sendUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //2.banding一个端口(可选),如果不绑定端口, 那么就会随机产生一个随机的电脑唯一的端口
    //端口数字范围(1024,2^16-1)
    NSError * error = nil;
    [sendUdpSocket bindToPort:123 error:&error];
    //启用广播
    [sendUdpSocket enableBroadcast:YES error:&error];
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        NSLog(@"监听成功则开始接收信息");
        [sendUdpSocket beginReceiving:&error];
    }
    
}
//5.发送消息
-(void)sendMessage:(NSString *)strM{
    
//    NSString *s = @"mapleTest";
    NSData *data = [strM dataUsingEncoding:NSUTF8StringEncoding];
    NSString *host = @"255.255.255.255";//此处如果写成固定的IP就是对特定的server监测；我这种写法是为了多方监测
//    NSString *host = @"192.168.26.62";
    uint16_t port = 123;//通过端口监测
    [sendUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:111];
}

//6.相关的代理
#pragma mark -GCDAsyncUdpSocketDelegate
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"看看发送消息的标记：%ld",tag);
    if (tag == 100) {
        NSLog(@"表示标记为100的数据发送完成了");
    }
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"filterContext：%@",filterContext);
    // 继续来等待接收下一次消息
    if (_receiveBlock) {
        _receiveBlock(ip,port,s);
    }
    
    [sock receiveOnce:nil];
    //此处根据实际和硬件商定的需求决定是否主动回一条消息
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self sendBackToHost:ip port:port withMessage:s];
//    });
}

- (void)receiveBlock:(ReceiveBlock)receiveBlock
{
    _receiveBlock = receiveBlock;
}


- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocket关闭");
}

//-(void)sendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)s{
//    NSString *msg = @"我收到了";
//    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
////    [sendUdpSocket sendData:data toHost:ip port:port withTimeout:0.1 tag:200];
//
//}

@end
