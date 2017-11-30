#import <Foundation/Foundation.h>


typedef void(^ReceiveBlock)(NSString *ip,uint16_t port,NSString *mes);

@interface UDPManage : NSObject 

+(instancetype)shareUDPManage;


-(void)sendMessage:(id )mes port:(uint16_t)port;


- (void)receiveBlock:(ReceiveBlock)receiveBlock;

@end
