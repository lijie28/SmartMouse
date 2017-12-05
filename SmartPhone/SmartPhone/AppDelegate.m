//
//  AppDelegate.m
//  SmartPhone
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <sys/socket.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSString *)localIPAddress
{
    NSString *localIP = nil;
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs)==0) {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                //NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                //if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
                {
                    localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    break;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口
//    self.window = [[UIWindow alloc]init];
//    self.window.frame = [UIScreen mainScreen].bounds;
//
//
//    //初始化tabBarVC
//    ViewController *vc = [[ViewController alloc]init];
//
//
//    //设置窗口的根控制器
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    self.window.rootViewController = nav;
    
    NSLog(@"ip:%@",[self localIPAddress]);
    return YES;
}

@end
