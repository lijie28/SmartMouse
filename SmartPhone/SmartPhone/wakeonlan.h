//
//  wakeonlan.h
//  SmartPhone
//
//  Created by JackLee on 2018/2/27.
//  Copyright © 2018年 Jack. All rights reserved.
//

#ifndef wakeonlan_h
#define wakeonlan_h




#include <stdio.h>

//void wakeup();

int send_wol(const char *hardware_addr, unsigned port, unsigned long bcast);

#endif /* wakeonlan_h */
