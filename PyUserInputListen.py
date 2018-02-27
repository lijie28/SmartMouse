# -*- coding:utf8 -*-

from pymouse import PyMouse
# from pykeyboard import PyKeyboard


ms = PyMouse()

# class MouseEvent(object):
#     """docstring for MouseEvent"""


def mouseMove(posx, posy, k):  
    currentpos = ms.position()
    nextX = (1+k) *(posx)+currentpos[0]
    nextY = (1+k) *(posy)+ currentpos[1]
    if (nextX>=0)&(nextY>=0):
        ms.move(nextX,nextY)

def singleClick():
    currentpos = ms.position()
    ms.click(currentpos[0],currentpos[1])

def doubleClick():
    currentpos = ms.position()
    ms.press(currentpos[0],currentpos[1])
    ms.release(currentpos[0],currentpos[1])
    ms.press(currentpos[0],currentpos[1])
    ms.release(currentpos[0],currentpos[1])
    
def rightClick():
    currentpos = ms.position()
    ms.click(currentpos[0],currentpos[1],2)

def pressDown():  
    currentpos = ms.position()
    ms.press(currentpos[0],currentpos[1])

def pressUp():  
    currentpos = ms.position()
    ms.release(currentpos[0],currentpos[1]) 
        
def pressMove(posx, posy, k):  
    currentpos = ms.position()
    nextX = (1+k) *(posx)+currentpos[0]
    nextY = (1+k) *(posy)+ currentpos[1]
    if (nextX>=0)&(nextY>=0):
        # ms.press(nextX,nextY)
        ms.drag(nextX,nextY)

def mouseScroll(distance):    
    ''''' 
    @param movement: lines to scroll, Integer  
    @param direction: scroll up or scroll down, 1:scroll up, -1:scroll down  
    '''
    currentpos = ms.position()
    ms.scroll(distance)

      


    # def __init__(self, arg):
    #     super(MouseEvent, self).__init__()
    #     self.arg = arg
        

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
    print currentpos[0],currentpos[1]
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
    #         x,y = pag.position()() #返回鼠标的坐标
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
    #mouseMove(int(currentpos[0]),int(currentpos[1])); # Restore mouse position  

