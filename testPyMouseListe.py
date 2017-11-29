#!/usr/bin/python  
''''' 
Created on 2013-8-30 
 
@author: maricoliu 
'''  
import sys  
import time  
from Quartz.CoreGraphics import *    

def _keyBoardEvent():
    push = CGEventCreateKeyboardEvent(None, kVK_ANSI_P, true)
    CGEventPost(kCGHIDEventTap, push)
    # CFRelease(push)


def _mouseEvent(type, posx, posy):  
    theEvent = CGEventCreateMouseEvent(None, type, (posx,posy), kCGMouseButtonLeft)  
    CGEventPost(kCGHIDEventTap, theEvent)  
      
def mouseMove(posx, posy):  
    _mouseEvent(kCGEventMouseMoved, posx, posy)  
      
def mouseClickDown(posx, posy):  
    _mouseEvent(kCGEventLeftMouseDown, posx, posy)  
      
def mouseClickUp(posx, posy):  
    _mouseEvent(kCGEventLeftMouseUp, posx, posy)  
      
def mouseDrag(posx, posy):  
    _mouseEvent(kCGEventLeftMouseDragged, posx, posy)  
      
def mouseClick(posx, posy):  
    '''''perform a left click'''  
    _mouseEvent(kCGEventLeftMouseDown, posx, posy)  
    _mouseEvent(kCGEventLeftMouseUp, posx, posy)  
      
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

    _keyBoardEvent()

    ourEvent = CGEventCreate(None);  
    currentpos=CGEventGetLocation(ourEvent); # Save current mouse position  |
    print currentpos.x,currentpos.y
    time.sleep(1);  
  
    for i in range(5):  
        # mouseScroll(40, 1)  
        # mouseScroll(40, -1)  
        time.sleep(1);  
        mouseMove(40*i,1)
      
    # mouseclick(1610, 215)  
    # mousedoubleclick(1697, 561)  
    time.sleep(1);  
    #mouseMove(int(currentpos.x),int(currentpos.y)); # Restore mouse position  