
#import "LYUDPBroadCastAndGetIP.h"

static LYUDPBroadCastAndGetIP * manager = nil;
@implementation LYUDPBroadCastAndGetIP

+(LYUDPBroadCastAndGetIP*)shared{
    
    @synchronized(self) {
        if (!manager) {
            manager = [[LYUDPBroadCastAndGetIP alloc]init];
        }
    }
    
    return manager;
}

-(void)sendBroadCastWithPort:(UInt16)port andCallBack:(callBackBlock)callBack{
    NSError * error = nil;
    self.callBackBlock = callBack;
    self.udpSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    [self.udpSocket enableBroadcast:YES error:&error];
    [self.udpSocket bindToPort:port error:&error];
    NSData * data = [@"mxchip" dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data toHost:@"255.255.255.255" port:port withTimeout:-1 tag:0];
    
    [self.udpSocket receiveWithTimeout:-1 tag:0];
    
    
}
-(void)gcdSocketGetIPWithPort:(UInt16)port andCallBack:(callBackBlock)callBack{
    self.getIPBlock = callBack;
    NSError *error = nil;
    allClientArray = [NSMutableArray array];// 创建一个后台的队列 等待接收数据
    dispatch_queue_t dQueue = dispatch_queue_create("My socket queue", NULL);
    self.gcdSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dQueue];
    [self.gcdSocket acceptOnPort:port error:&error];
}

#pragma mark asyncsocket 的代理方法
//已接收到消息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
    self.callBackBlock(host,port);
    return YES;
}
//没有接受到消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"not received");
}
//没有发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"%@",error);
    
    NSLog(@"not send");
}
//已发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"send");
}
//断开连接
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"closed");
}

#pragma mark gcdsocket 的代理方法

#pragma mark - 代理方法 接收到一个请求
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    NSString *ip = [newSocket connectedHost];
    uint16_t port = [newSocket connectedPort];
    // 这个代理函数被调用的时候就是表示 有人连接我了
    // newSocket就是新的socket
    // self.getIPBlock(newSocket,0);
    NSLog(@"new socket [%@:%d] is %@", ip, port, newSocket);
    
    [allClientArray addObject:newSocket];
    // 一直死等读取newSocket的消息
    [newSocket readDataWithTimeout:-1 tag:200];
    //[[MagicBeanSocket defaultSocket] startSocket];
    // 写一些echo信息
    NSString *s = @"Welcome";
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    [newSocket writeData:data withTimeout:60 tag:300];
}

#pragma mark - 接收到数据代理函数
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    self.getIPBlock(ip,port);
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到tcp [%@:%d] %@", ip, port, s);
    
    NSString *s2 = [NSString stringWithFormat:@"你发的数据是:%@", s];
    NSData *databack = [s2 dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:databack withTimeout:60 tag:400];
    
    // 再次接收数据 因为这个方法只接收一次
    [sock readDataWithTimeout:-1 tag:200];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"失去连接 %@", err);
    [allClientArray removeObject:sock];
}

@end

//需要注意的是广播的数据要双方定义好。不然没反应。
