#import <Foundation/Foundation.h>


typedef void(^ReceiveBlock)(NSString *ip,uint16_t port,id mes);

@interface UDPManage : NSObject 

+(instancetype)shareUDPManage;


-(void)sendMessage:(id )mes ipHost:(NSString *)ipHost port:(uint16_t)port;


- (void)receiveBlock:(ReceiveBlock)receiveBlock;

- (void)checkAset;
@end
