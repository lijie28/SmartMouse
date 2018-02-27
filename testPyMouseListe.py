#!/usr/bin/python  
# -*- coding:utf8 -*-
''''' 
Created on 2013-8-30 
 
@author: maricoliu 
'''  
import sys  
import time  
from Quartz.CoreGraphics import *    
import pyperclip

reload(sys)
sys.setdefaultencoding('utf-8')


class MouseEvent(object):
    """docstring for MouseEvent"""

    def _mouseEvent(type, posx, posy):  
        theEvent = CGEventCreateMouseEvent(None, type, (posx,posy), kCGMouseButtonLeft)  
        CGEventPost(kCGHIDEventTap, theEvent)  

    def getpos():
        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse 
        return currentpos.x,currentpos.y    
          
    def move(posx, posy):  
        _mouseEvent(kCGEventMouseMoved, posx, posy)  

    def pressmove(posx, posy, k):  
        print 'mousePressMove',posx,posy
        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse 

        nextX = (1+k) *(posx)+currentpos.x
        nextY = (1+k) *(posy)+ currentpos.y
        if (nextX>=0)&(nextY>=0):
            _mouseEvent(kCGEventLeftMouseDragged, nextX, nextY)
            # _mouseEvent(kCGEventMouseMoved,nextX, nextY)



    def mouseMove(posx, posy, k):  

        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse 

        nextX = (1+k) *(posx)+currentpos.x
        nextY = (1+k) *(posy)+ currentpos.y
        if (nextX>=0)&(nextY>=0):
            
            _mouseEvent(kCGEventMouseMoved,nextX, nextY)
        
    def click(clickType):
        if clickType == '':
            pass


    def mouseDoubleClickHere():
        mouseDoubleClick(_getpos())


    def mouseLeftClickHere():
        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse 
        mouseLeftClick(currentpos.x,currentpos.y)
        

    def mouseClickDownHere():  
        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
        mouseClickDown(currentpos.x,currentpos.y)

    def mouseClickDown(posx, posy):  
        _mouseEvent(kCGEventLeftMouseDown, posx, posy)  
          

    def mouseClickUpHere():  
        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
        mouseClickUp(currentpos.x,currentpos.y)

    def mouseClickUp(posx, posy):  
        _mouseEvent(kCGEventLeftMouseUp, posx, posy)  
          
    def mouseDrag(posx, posy):  
        _mouseEvent(kCGEventLeftMouseDragged, posx, posy)  
          
    def mouseClick(posx, posy):  
        '''''perform a left click'''  
        _mouseEvent(kCGEventLeftMouseDown, posx, posy)  
        _mouseEvent(kCGEventLeftMouseUp, posx, posy)  
          

    def mouseLeftClickUpHere():
        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
        mouseLeftClickUp(currentpos.x,currentpos.y)

    def mouseLeftClickUp(posx, posy):  
        theEvent = CGEventCreateMouseEvent(None,kCGEventLeftMouseUp , (posx,posy), kCGMouseButtonLeft)  
        CGEventPost(kCGHIDEventTap, theEvent)  

    def mouseLeftClickDownHere():
        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
        mouseLeftClickDown(currentpos.x,currentpos.y)
          
    def mouseLeftClickDown(posx, posy):  
        theEvent2 = CGEventCreateMouseEvent(None, kCGEventLeftMouseDown, (posx,posy), kCGMouseButtonLeft)  
        CGEventPost(kCGHIDEventTap, theEvent2) 


    def mouseLeftClick(posx, posy):  
        theEvent = CGEventCreateMouseEvent(None, kCGEventLeftMouseDown, (posx,posy), kCGMouseButtonLeft)  
        CGEventPost(kCGHIDEventTap, theEvent)  
        theEvent2 = CGEventCreateMouseEvent(None, kCGEventLeftMouseUp, (posx,posy), kCGMouseButtonLeft)  
        CGEventPost(kCGHIDEventTap, theEvent2) 


    def mouseRightClickHere():  
        ourEvent = CGEventCreate(None);  
        currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
        mouseRightClick(currentpos.x,currentpos.y)

    def mouseRightClick(posx, posy):  
            theEvent = CGEventCreateMouseEvent(None, kCGEventRightMouseDown, (posx,posy), kCGMouseButtonRight)  
            CGEventPost(kCGHIDEventTap, theEvent)  
            theEvent2 = CGEventCreateMouseEvent(None, kCGEventRightMouseUp, (posx,posy), kCGMouseButtonRight)  
            CGEventPost(kCGHIDEventTap, theEvent2)  

      
    def mouseDoubleClick(posx, posy):  
        '''''perfrom a double left click'''  
        theEvent = CGEventCreateMouseEvent(None, kCGEventLeftMouseDown, (posx,posy), kCGMouseButtonLeft);    
        CGEventPost(kCGHIDEventTap, theEvent);    
        CGEventSetType(theEvent, kCGEventLeftMouseUp);    
        CGEventPost(kCGHIDEventTap, theEvent);   
        CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, 2);     
        CGEventSetType(theEvent, kCGEventLeftMouseDown);    
        CGEventPost(kCGHIDEventTap, theEvent);    
        CGEventSetType(theEvent, kCGEventLeftMouseUp);   
        CGEventPost(kCGHIDEventTap, theEvent);  
      
    def mouseScroll(distance):    
        ''''' 
        @param movement: lines to scroll, Integer  
        @param direction: scroll up or scroll down, 1:scroll up, -1:scroll down  
        '''        
            
        # theEvent = CGEventCreateScrollWheelEvent(None, kCGScrollEventUnitLine, 1, distance)  
        # CGEventPost(kCGHIDEventTap, theEvent)        
        # CGPostScrollWheelEvent(10, -3)  
        def scroll(self, vertical=None, horizontal=None, depth=None):
                #Local submethod for generating Mac scroll events in one axis at a time
            def scroll_event(y_move=0, x_move=0, z_move=0, n=1):
                for _ in range(abs(n)):
                    scrollWheelEvent = Quartz.CGEventCreateScrollWheelEvent(
                        None,  # No source
                        Quartz.kCGScrollEventUnitLine,  # Unit of measurement is lines
                        3,  # Number of wheels(dimensions)
                        y_move,
                        x_move,
                        z_move)
                    Quartz.CGEventPost(Quartz.kCGHIDEventTap, scrollWheelEvent)

            #Execute vertical then horizontal then depth scrolling events
            if vertical is not None:
                vertical = int(vertical)
                if vertical == 0:   # Do nothing with 0 distance
                    pass
                elif vertical > 0:  # Scroll up if positive
                    scroll_event(y_move=1, n=vertical)
                else:  # Scroll down if negative
                    scroll_event(y_move=-1, n=abs(vertical))
            if horizontal is not None:
                horizontal = int(horizontal)
                if horizontal == 0:  # Do nothing with 0 distance
                    pass
                elif horizontal > 0:  # Scroll right if positive
                    scroll_event(x_move=1, n=horizontal)
                else:  # Scroll left if negative
                    scroll_event(x_move=-1, n=abs(horizontal))
            if depth is not None:
                depth = int(depth)
                if depth == 0:  # Do nothing with 0 distance
                    pass
                elif vertical > 0:  # Scroll "out" if positive
                    scroll_event(z_move=1, n=depth)
                else:  # Scroll "in" if negative
                    scroll_event(z_move=-1, n=abs(depth))

        scroll(distance)

    def __init__(self, arg):
        super(MouseEvent, self).__init__()
        self.arg = arg
        


def keyboardInput(str):
    pyperclip.copy(str)
    keyBoardEventCommandType(0x09)

def keyBoardEventCommandType(key):
    push = CGEventCreateKeyboardEvent(None, key, True)
    CGEventSetFlags(push, kCGEventFlagMaskCommand);
    CGEventPost(kCGSessionEventTap, push)

def keyBoardEventType(key):
    push = CGEventCreateKeyboardEvent(None, key, True)
    CGEventPost(kCGHIDEventTap, push)

  
if __name__ == '__main__':  

    # _keyBoardEvent()#打印'o'

    ourEvent = CGEventCreate(None);  
    currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
    print currentpos.x,currentpos.y
    mouseScroll(3)
    # keyboardInput('测试')
    # pyautogui.typewrite('哈哈')
    # k = PyKeyboard()
    # pyperclip.copy("哈哈测试")
    # # pyperclip.paste()
    # _keyBoardEventPaste()
    # time.sleep(1);  
    # # mouseMove
    
    # for i in range(5):  
    #     # mouseScroll(40, 1)  
    #     # mouseScroll(40, -1)  
    #     time.sleep(1);  
    #     mouseMove(40*i,1)

    # hm = pyHook.HookManager()
    # hm.HookKeyboard()
    # hm.MouseAllButtonsDown = onMouseEvent
    # hm.MouseAllButtonsUp = onMouseEvent
    # hm.HookMouse()
    # pythoncom.PumpMessages()
    # onMouseEvent
    # try:
    #     while True:
    #         print "Press Ctrl-C to end"
    #         x,y = pag.position() #返回鼠标的坐标
    #         posStr="Position:"+str(x).rjust(4)+','+str(y).rjust(4)
    #         print posStr#打印坐标
    #         time.sleep(0.2)
    #         os.system('cls')#清楚屏幕
    # except  KeyboardInterrupt:
    #     print 'end....'

    # print CGEventGetLocation(GetMousePoint)
    # print CGEventGetLocation(1)

      
    # mouseclick(1610, 215)  
    # mousedoubleclick(1697, 561)  
    # time.sleep(1);  
    #mouseMove(int(currentpos.x),int(currentpos.y)); # Restore mouse position  

