#!/usr/bin/env python
# -*- coding:utf8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import socket
import time  
# import testPyMouseListe as MouseCtrl
import json
from pymouse import PyMouse

class UdpServer(object):
    def tcpServer(self):
        print 'enter serve'
        count = 0
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.bind(('', 9228))       # 绑定同一个域名下的所有机器
        
        while True:
            revcData, (remoteHost, remotePort) = sock.recvfrom(1024)

            data = eval(revcData)
            # print data['action']
            if data['action'] == 'mouseMove':
                print data['value']
                p = mouse.position()
                mouse.move(p[0]+data['value']['x'],p[1]+data['value']['y'])

            elif data['action'] == 'mouseDoubleClick':
                print 'double'
                p = mouse.position()
                mouse.press(p[0],p[1])
                mouse.release(p[0],p[1])
                mouse.press(p[0],p[1])
                mouse.release(p[0],p[1])

            elif data['action'] == 'mouseSingleClick':
                print 'single'
                mouse.press(p[0],p[1])
                mouse.release(p[0],p[1])

            elif data['action'] == 'leftClickDown':
                print 'leftClickDown'
            elif data['action'] == 'leftClickUp':
                print 'leftClickUp'
            elif data['action'] == 'rightClick':
                print 'rightClick'
            elif data['action'] == 'keyboardInput':
                print 'keyboardInput'
            elif data['action'] == 'mousePressMove':
                print data['value']
            elif data['action'] == 'keyboardType':
                print 'keyboardType',data['value']
            elif data['action'] == 'keyboardCommandType':
                print 'keyboardCommandType',data['value']
            elif data['action'] == 'mouseScroll':
                print 'mouseScroll',data['value']

            elif data['action'] == 'searchForConection':
                # mes = "收到 %d" % count
                name = socket.getfqdn(socket.gethostname()) 
                mes = json.dumps({'action': 'receive','value': name })
                
                sendDataLen = sock.sendto(mes,(remoteHost, remotePort))
            
                
            #回应
            # 


            
        sock.close()
            
if __name__ == "__main__":
    udpServer = UdpServer()
    udpServer.tcpServer()