#!/usr/bin/env python
# -*- coding:utf8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import socket
import time  
import testPyMouseListe as mouseCtrl
import json

class UdpServer(object):
    def tcpServer(self):
        print 'enter serve'
        count = 0
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.bind(('', 9527))       # 绑定同一个域名下的所有机器
        
        while True:
            revcData, (remoteHost, remotePort) = sock.recvfrom(1024)

            data = eval(revcData)
            # revcData = revcData.replace(' ', '')
            # revcData = revcData.replace("\n", "")
            # print("[%s:%s] --" % (remoteHost, remotePort)),revcData     # 接收客户端的ip, port
            # print revcData
            # if (revcData['action'] == 'mouseMove'):
            #     print 'yes_hah'
            # json_str = json.dumps(revcData)
            print data['action']
            
            # print ("python原始数据：", repr(revcData))  
            # print ("json对象：", json_str) 
            
            # for i in range(5):  
            # # mouseScroll(40, 1)  
            # # mouseScroll(40, -1)  
            #     time.sleep(1);  
            #     mouseCtrl.mouseMove(40*i,1)

            mes = "收到 %d" % count
            sendDataLen = sock.sendto(mes,(remoteHost, remotePort))
            count =  count+1
            # print "revcData: ", revcData
            # print "sendDataLen: ", sendDataLen
            # print "remoteHost: ", remoteHost,"remotePort: ", remotePort


            
        sock.close()
            
if __name__ == "__main__":
    udpServer = UdpServer()
    udpServer.tcpServer()