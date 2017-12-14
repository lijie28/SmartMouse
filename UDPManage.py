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
        sock.bind(('', 9228))       # 绑定同一个域名下的所有机器
        
        while True:
            revcData, (remoteHost, remotePort) = sock.recvfrom(1024)

            data = eval(revcData)
            # print data['action']
            if data['action'] == 'mouseMove':
                print data['value']
                MouseCtrl.mouseMove(data['value']['x'],data['value']['y'],data['value']['k'])

            elif data['action'] == 'mouseDoubleClick':
                print 'double'
                MouseCtrl.mouseDoubleClickHere()

            elif data['action'] == 'mouseSingleClick':
                print 'single'
                MouseCtrl.mouseLeftClickHere()
            elif data['action'] == 'leftClickDown':
                print 'leftClickDown'
                MouseCtrl.mouseLeftClickDownHere()
            elif data['action'] == 'leftClickUp':
                print 'leftClickUp'
                MouseCtrl.mouseLeftClickUpHere()
            elif data['action'] == 'rightClick':
                print 'rightClick'
                MouseCtrl.mouseRightClickHere()
            elif data['action'] == 'keyboardInput':
                print 'keyboardInput'
                MouseCtrl.keyboardInput(data['value'])
            elif data['action'] == 'mousePressMove':
                print data['value']
                MouseCtrl.mousePressMove(data['value']['x'],data['value']['y'],data['value']['k'])
            elif data['action'] == 'keyboardType':
                print 'keyboardType',data['value']
                MouseCtrl.keyBoardEventType(data['value'])
            elif data['action'] == 'keyboardCommandType':
                print 'keyboardCommandType',data['value']
                MouseCtrl.keyBoardEventCommandType(data['value'])
            elif data['action'] == 'mouseScroll':
                print 'mouseScroll',data['value']
                MouseCtrl.mouseScroll(data['value'])

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