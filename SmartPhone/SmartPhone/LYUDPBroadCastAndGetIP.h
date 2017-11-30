#import <Foundation/Foundation.h>

#import "AsyncUdpSocket.h"

#import "GCDAsyncSocket.h"
typedef void(^callBackBlock)(id sender,UInt16 port);
@interface LYUDPBroadCastAndGetIP : NSObject<AsyncUdpSocketDelegate,GCDAsyncSocketDelegate>{
    
    NSMutableArray * allClientArray;
}


@property (nonatomic,strong)AsyncUdpSocket * udpSocket;
@property (nonatomic,strong)GCDAsyncSocket * gcdSocket;
@property (nonatomic,copy)callBackBlock callBackBlock;
@property (nonatomic,copy)callBackBlock getIPBlock;

+(LYUDPBroadCastAndGetIP*)shared;
-(void)sendBroadCastWithPort:(UInt16)port andCallBack:(callBackBlock)callBack;
-(void)gcdSocketGetIPWithPort:(UInt16)port andCallBack:(callBackBlock)callBack;

@end
