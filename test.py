#!/usr/local/bin/python3
#coding:utf-8

import string, subprocess

tcptmpStr = ((subprocess.check_output(["netstat", "-ntlp"])).decode('utf-8')).strip()
udptmpStr = ((subprocess.check_output(["netstat", "-nulp"])).decode('utf-8')).strip()
#get tcp port and service

def getTCPservice(tcptmpStr):
        tmpList = tcptmpStr.split("\n")
#        del tmpList[0:2]
        newList = []
        
        for i in tmpList:
            val = i.split()
            del val[0:3]
            del val[1:3]
            valTmp = (val[0].split(":"))[-1]
            val[0] = valTmp
            valTmp = val[1].split('/')
            val[1] = valTmp[-1]
            val = ' '.join(val)
            newList.append(val)
        return newList
    
#get udp port and service 

def getUDPservice(udptmpStr):        
        tmpList = udptmpStr.split("\n")
        del tmpList[0:2]
        newList = []
        
        for i in tmpList:
            val = i.split()
            del val[0:3]
            del val[1]
            valTmp = (val[0].split(":"))[-1]
            val[0] = valTmp
            valTmp = val[1].split('/')
            val[1] = valTmp[-1]
            val = ' '.join(val)
            newList.append(val)
        return newList

#def tcpService():     
for i in getTCPservice(tcptmpStr):
    val = i.split(' ', 1)
    port, app = val
    print(port, app) 



#def udpService():
for i in getUDPservice(udptmpStr):
    val = i.split(' ', 1)
    port, app = val
    print(port, app)



    


# if __name__ == "__main__":
#     udpServer = UdpServer()
#     getUDPservice.tcpServer()