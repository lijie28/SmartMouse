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
@property (strong, nonatomic)UILabel *showLog;
@property (strong, nonatomic)UIButton *btnSend;
@property (strong, nonatomic)UIImageView *imageV;

@end
int count;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"打开app");
    self.showLog.text = @"打开app";
    self.btnSend.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UDPManage shareUDPManage]receiveBlock:^(NSString *ip, uint16_t port, NSString *mes) {
        
        NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, mes);
        
        [self appendStr:mes];
    }];

    self.imageV.hidden = NO;
}


#pragma mark--touch开始的时候
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch=[touches anyObject];
    CGPoint current=[touch locationInView:self.view];
    _imageV.center=CGPointMake(current.x, current.y);
    
}

#pragma mark--touch移动中
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    
    //取得当前位置
    CGPoint current=[touch locationInView:self.view];
    //取得前一个位置
    CGPoint previous=[touch previousLocationInView:self.view];
    
    //移动前的中点位置
    CGPoint center=_imageV.center;
    //移动偏移量
    CGPoint offset=CGPointMake(current.x-previous.x, current.y-previous.y);
    if (offset.x == 0&&offset.y == 0) return;
    
    NSLog(@"X:%f Y:%f",offset.x,offset.y);
    
    NSDictionary *dic =
  @{@"action":@"mouseMove",
    @"value":@{@"x":@(offset.x),@"y":@(offset.y)
            },
                          };
    
    
    //重新设置新位置
    _imageV.center=CGPointMake(center.x+offset.x, center.y+offset.y);
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
    
    NSLog(@"X:%f Y:%f",offset.x,offset.y);
    
    //重新设置新位置
    _imageV.center=CGPointMake(offset.x,offset.y);
}


- (void)appendStr:(NSString *)str
{
    
    self.showLog.text = [NSString stringWithFormat:@"%@ \n%@",self.showLog.text,str];
}


- (void)send
{
//    count ++;
    [[UDPManage shareUDPManage]sendMessage:[NSString stringWithFormat:@"发送：%d",count++] port:9527];
}






#pragma mark - lazy init
- (UIImageView *)imageV
{
    if (!_imageV) {
        _imageV=[[UIImageView alloc]init];
        _imageV.frame=CGRectMake(50, 50, 50, 50);
        _imageV.image=[UIImage imageNamed:@"check.png"];
        _imageV.backgroundColor = [UIColor yellowColor];
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
        _btnSend.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_btnSend];
    }
    return _btnSend;
}

@end
