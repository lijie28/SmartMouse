//
//  ViewController.m
//  SmartPhone
//
//  Created by Jack on 2017/11/29.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "UDPManage.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewTouch;
//@property (strong, nonatomic)UIView *touchBg;
@property (strong, nonatomic)UILabel *showLog;
@property (strong, nonatomic)UIButton *btnSend;
@property (strong, nonatomic)UIImageView *imageV;
@property (assign, nonatomic)NSTimeInterval lastTime;

@end
int count;
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [self addGesture];
    self.btnSend.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UDPManage shareUDPManage]receiveBlock:^(NSString *ip, uint16_t port, NSString *mes) {
        NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, mes);
//        [self appendStr:mes];
    }];

    self.imageV.hidden = NO;
    
}


- (void)addGesture
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [_viewTouch addGestureRecognizer:singleTapGestureRecognizer];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [_viewTouch addGestureRecognizer:doubleTapGestureRecognizer];
}


#pragma mark - 手势部分
- (void)singleTap:(UITapGestureRecognizer *)singleTap
{
    NSLog(@"单击");
    NSDictionary *dic =
    @{@"action":@"mouseSingleClick",
      };
    [[UDPManage shareUDPManage]sendMessage:dic port:9527];
}
- (void)doubleTap:(UITapGestureRecognizer *)doubleTap
{
    
    NSLog(@"双击");
    
    NSDictionary *dic =
    @{@"action":@"mouseDoubleClick",
      };
    [[UDPManage shareUDPManage]sendMessage:dic port:9527];
}


#pragma mark--touch开始的时候
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch=[touches anyObject];
//    if (touch.view != self.touchBg) return;
    
    CGPoint current=[touch locationInView:self.view];
    _imageV.center=CGPointMake(current.x, current.y);
    
    _lastTime = 0;
}

#pragma mark--touch移动中
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if (touch.view != self.viewTouch) return;
//    NSLog(@"手指数：%lu",(unsigned long)touch.tapCount);
    /*
     - (CGPoint)locationInView:(nullableUIView *)view;//现在触摸的坐标
     - (CGPoint)previousLocationInView:(nullableUIView *)view;//上一次触摸的坐标
     - (CGPoint)preciseLocationInView:(nullableUIView *)view NS_AVAILABLE_IOS(9_1);//现在触摸的精确的坐标
     - (CGPoint)precisePreviousLocationInView:(nullableUIView *)view NS_AVAILABLE_IOS(9_1);//上一次触摸的精确的坐标
     */
    //取得当前位置
    CGPoint current=[touch preciseLocationInView:self.view];//
    //取得前一个位置
    CGPoint previous=[touch precisePreviousLocationInView:self.view];
    
    //移动前的中点位置
    CGPoint center=_imageV.center;
    //移动偏移量
    CGPoint offset=CGPointMake(current.x-previous.x, current.y-previous.y);
    if (offset.x == 0&&offset.y == 0) return;
    
//    NSLog(@"X:%f Y:%f",offset.x,offset.y);
    
    
    
    //重新设置新位置
    _imageV.center=CGPointMake(center.x+offset.x, center.y+offset.y);
    
    
    
    //速度算法（比较随便 要优化）
    CGFloat s = 0.0;
    CGFloat t = 0.0;
    CGFloat v = 0.0;
    CGFloat k = 0.0;
    s =sqrt(offset.x*offset.x +offset.y*offset.y);
    NSTimeInterval time = [touch timestamp];
    if (_lastTime !=0 ) {
        t = time - _lastTime;
    }
    if (t !=0 ) {
        v = s/t;
    }
    
    _lastTime = time;
    if (v>1000) {
        
        NSLog(@"s:%f,t:%f,v:%f，a:%f",s,t,v,k);
        k = (v-1000)/1000;
    }
    
    
    NSDictionary *dic =
    @{@"action":@"mouseMove",
      @"value":@{@"x":@(offset.x),@"y":@(offset.y),@"k":@(k)
                 },
      };
    [[UDPManage shareUDPManage]sendMessage:dic port:9527];
}


#pragma mark--touch移动结束
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    
    //取得当前位置
    CGPoint current=[touch locationInView:self.view];
    //取得前一个位置
    
    //移动前的中点位置
    //    CGPoint center=imageV.center;
    //移动偏移量
    CGPoint offset=CGPointMake(current.x, current.y);
    
//    NSLog(@"X:%f Y:%f",offset.x,offset.y);
    
    //重新设置新位置
    _imageV.center=CGPointMake(offset.x,offset.y);
    
    _lastTime = 0;
}


- (void)appendStr:(NSString *)str
{
    
    self.showLog.text = [NSString stringWithFormat:@"%@ \n%@",self.showLog.text,str];
}


- (void)send
{
    [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//    
//}
//
//- (BOOL)shouldAutorotate{
//    
//    return NO;
//}

//- (NSUInteger)supportedInterfaceOrientations﻿{
//    return UIInterfaceOrientationMaskPortrait;
//}



#pragma mark - lazy init
- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV=[[UIImageView alloc]init];
        _imageV.frame=CGRectMake(50, 50, 50, 50);
//        _imageV.image=[UIImage imageNamed:@"check.png"];
//        _imageV.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:_imageV];
    }
    return _imageV;
}


- (UILabel *)showLog
{
    if (!_showLog) {
        _showLog = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100)];
        _showLog.textAlignment = NSTextAlignmentCenter;
        _showLog.numberOfLines = 0;
        [self.view addSubview:_showLog];
    }
    return _showLog;
}

- (UIButton *)btnSend
{
    if (!_btnSend) {
        _btnSend = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2- 200/2, 20, 200, 60)];
        [_btnSend addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        _btnSend.backgroundColor = [UIColor grayColor];
        [_btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnSend setTitle:@"切换" forState:UIControlStateNormal];
        [self.view addSubview:_btnSend];
    }
    return _btnSend;
}
//- (UIView *)touchBg
//{
//    if (!_touchBg) {
//        _touchBg = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight - 200)];
//
//        _touchBg.backgroundColor = [UIColor lightGrayColor];
//        [self.view addSubview:_touchBg];
//
//
//    }
//    return _touchBg;
//}
@end
