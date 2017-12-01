#!/usr/bin/env python
# -*- coding:utf8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import socket
import time  
import testPyMouseListe as MouseCtrl
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
            # print data['action']
            if data['action'] == 'mouseMove':
                print data['value']
                MouseCtrl.mouseMove(data['value']['x'],data['value']['y'],data['value']['k'])


            if data['action'] == 'mouseDoubleClick':
                print 'double'
                MouseCtrl.mouseDoubleClickHere()

            if data['action'] == 'mouseSingleClick':
                print 'single'
                MouseCtrl.mouseLeftClickHere()


            #回应
            # mes = "收到 %d" % count
            # sendDataLen = sock.sendto(mes,(remoteHost, remotePort))
            # count =  count+1


            
        sock.close()
            
if __name__ == "__main__":
    udpServer = UdpServer()
    udpServer.tcpServer()