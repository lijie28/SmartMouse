#include <stdio.h>
#include <sys/termios.h>
#include <unistd.h>

#include<stdlib.h>
#include<time.h>
#include<windows>

static struct termios initial_settings, new_settings;
static int peek_character = -1;
void init_keyboard(void);
void close_keyboard(void);
int kbhit(void);
int readch(void);

int main(){
    int x,y;
    POINT p;//定义一个POINT变量，用于存储鼠标的坐标
    srand(time(NULL));//随机初始化
    GetCursorPos(&p);//获取鼠标位置
    printf("当前的鼠标坐标为：x:%d,y:%d\n",p.x,p.y);
    Sleep(2000);//暂停2秒
    x=rand()%1364;
    y=rand()%768;
    SetCursorPos(x,y);//将鼠标移到一个随机的坐标
    printf("已将鼠标移至：x:%d,y:%d\n",x,y);
    system("pause>nul");
    return 0;
}

void init_keyboard()

{
    tcgetattr(0,&initial_settings);
    new_settings = initial_settings;
    new_settings.c_lflag |= ICANON;
    new_settings.c_lflag |= ECHO;
    new_settings.c_lflag |= ISIG;
    new_settings.c_cc[VMIN] = 1;
    new_settings.c_cc[VTIME] = 0;
    tcsetattr(0, TCSANOW, &new_settings);
}

void close_keyboard()
{
    tcsetattr(0, TCSANOW, &initial_settings);
}

int kbhit()
{
    unsigned char ch;
    int nread;
    
    if (peek_character != -1) return 1;
    new_settings.c_cc[VMIN]=0;
    tcsetattr(0, TCSANOW, &new_settings);
    nread = read(0,&ch,1);
    new_settings.c_cc[VMIN]=1;
    tcsetattr(0, TCSANOW, &new_settings);
    if(nread == 1)
    {
        peek_character = ch;
        return 1;
    }
    return 0;
}

int readch()
{
    char ch;
    
    if(peek_character != -1)
    {
        ch = peek_character;
        peek_character = -1;
        return ch;
    }
    read(0,&ch,1);
    return ch;
}

int main()
{
    init_keyboard();
    printf("hear");
    while(1)
    {
        kbhit();
        printf("\n%d\n", readch());
    }
    close_keyboard();
    return 0;
}
