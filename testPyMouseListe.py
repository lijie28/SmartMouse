#!/usr/bin/python  
# -*- coding:utf8 -*-
''''' 
Created on 2013-8-30 
 
@author: maricoliu 
'''  
import sys  
import time  
from Quartz.CoreGraphics import *    

# import os
# import pyautogui as pag

# enum {
#   kVK_ANSI_A                    = 0x00,
#   kVK_ANSI_S                    = 0x01,
#   kVK_ANSI_D                    = 0x02,
#   kVK_ANSI_F                    = 0x03,
#   kVK_ANSI_H                    = 0x04,
#   kVK_ANSI_G                    = 0x05,
#   kVK_ANSI_Z                    = 0x06,
#   kVK_ANSI_X                    = 0x07,
#   kVK_ANSI_C                    = 0x08,
#   kVK_ANSI_V                    = 0x09,
#   kVK_ANSI_B                    = 0x0B,
#   kVK_ANSI_Q                    = 0x0C,
#   kVK_ANSI_W                    = 0x0D,
#   kVK_ANSI_E                    = 0x0E,
#   kVK_ANSI_R                    = 0x0F,
#   kVK_ANSI_Y                    = 0x10,
#   kVK_ANSI_T                    = 0x11,
#   kVK_ANSI_1                    = 0x12,
#   kVK_ANSI_2                    = 0x13,
#   kVK_ANSI_3                    = 0x14,
#   kVK_ANSI_4                    = 0x15,
#   kVK_ANSI_6                    = 0x16,
#   kVK_ANSI_5                    = 0x17,
#   kVK_ANSI_Equal                = 0x18,
#   kVK_ANSI_9                    = 0x19,
#   kVK_ANSI_7                    = 0x1A,
#   kVK_ANSI_Minus                = 0x1B,
#   kVK_ANSI_8                    = 0x1C,
#   kVK_ANSI_0                    = 0x1D,
#   kVK_ANSI_RightBracket         = 0x1E,
#   kVK_ANSI_O                    = 0x1F,
#   kVK_ANSI_U                    = 0x20,
#   kVK_ANSI_LeftBracket          = 0x21,
#   kVK_ANSI_I                    = 0x22,
#   kVK_ANSI_P                    = 0x23,
#   kVK_ANSI_L                    = 0x25,
#   kVK_ANSI_J                    = 0x26,
#   kVK_ANSI_Quote                = 0x27,
#   kVK_ANSI_K                    = 0x28,
#   kVK_ANSI_Semicolon            = 0x29,
#   kVK_ANSI_Backslash            = 0x2A,
#   kVK_ANSI_Comma                = 0x2B,
#   kVK_ANSI_Slash                = 0x2C,
#   kVK_ANSI_N                    = 0x2D,
#   kVK_ANSI_M                    = 0x2E,
#   kVK_ANSI_Period               = 0x2F,
#   kVK_ANSI_Grave                = 0x32,
#   kVK_ANSI_KeypadDecimal        = 0x41,
#   kVK_ANSI_KeypadMultiply       = 0x43,
#   kVK_ANSI_KeypadPlus           = 0x45,
#   kVK_ANSI_KeypadClear          = 0x47,
#   kVK_ANSI_KeypadDivide         = 0x4B,
#   kVK_ANSI_KeypadEnter          = 0x4C,
#   kVK_ANSI_KeypadMinus          = 0x4E,
#   kVK_ANSI_KeypadEquals         = 0x51,
#   kVK_ANSI_Keypad0              = 0x52,
#   kVK_ANSI_Keypad1              = 0x53,
#   kVK_ANSI_Keypad2              = 0x54,
#   kVK_ANSI_Keypad3              = 0x55,
#   kVK_ANSI_Keypad4              = 0x56,
#   kVK_ANSI_Keypad5              = 0x57,
#   kVK_ANSI_Keypad6              = 0x58,
#   kVK_ANSI_Keypad7              = 0x59,
#   kVK_ANSI_Keypad8              = 0x5B,
#   kVK_ANSI_Keypad9              = 0x5C


def _keyBoardEvent():
    print '_keyBoardEvent'
    push = CGEventCreateKeyboardEvent(None, 0x1F, True)
    CGEventPost(kCGHIDEventTap, push)
    # CFRelease(push)


def _mouseEvent(type, posx, posy):  
    theEvent = CGEventCreateMouseEvent(None, type, (posx,posy), kCGMouseButtonLeft)  
    CGEventPost(kCGHIDEventTap, theEvent)  
      
def mouseMoveTo(posx, posy):  
    _mouseEvent(kCGEventMouseMoved, posx, posy)  

def mouseMove(posx, posy, k):  

    ourEvent = CGEventCreate(None);  
    currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
    nextX = (1+k) *(posx)+currentpos.x
    nextY = (1+k) *(posy)+ currentpos.y
    if (nextX>=0)&(nextY>=0):
        _mouseEvent(kCGEventMouseMoved,nextX, nextY)
    
        
def mouseDoubleClickHere():
    ourEvent = CGEventCreate(None);  
    currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
    mouseDoubleClick(currentpos.x,currentpos.y)


def mouseLeftClickHere():
    ourEvent = CGEventCreate(None);  
    currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
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
    theEvent = CGEventCreateMouseEvent(None, kCGEventLeftMouseDown, (posx,posy), kCGMouseButtonLeft)  
    CGEventPost(kCGHIDEventTap, theEvent)  

def mouseLeftClickDownHere():
    ourEvent = CGEventCreate(None);  
    currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
    mouseLeftClickDown(currentpos.x,currentpos.y)
      
def mouseLeftClickDown(posx, posy):  
    theEvent2 = CGEventCreateMouseEvent(None, kCGEventLeftMouseUp, (posx,posy), kCGMouseButtonLeft)  
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
  
def mouseScroll(movement=30, direction=1):    
    ''''' 
    @param movement: lines to scroll, Integer  
 
 
 
    @param direction: scroll up or scroll down, 1:scroll up, -1:scroll down  
    '''        
    for i in range(movement):  
        theEvent = CGEventCreateScrollWheelEvent(None, kCGScrollEventUnitLine, 1, direction)  
        CGEventPost(kCGHIDEventTap, theEvent)  
        time.sleep(0.02)         
    #CGPostScrollWheelEvent(1, 5)  
  
  
if __name__ == '__main__':  

    # _keyBoardEvent()#打印'o'

    ourEvent = CGEventCreate(None);  
    currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
    print currentpos.x,currentpos.y
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

