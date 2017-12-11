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

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewTouch;
//@property (strong, nonatomic)UIView *touchBg;
//@property (strong, nonatomic)UILabel *showLog;
//@property (strong, nonatomic)UIButton *btnSend;
@property (strong, nonatomic)UIImageView *imageV;
@property (assign, nonatomic)NSTimeInterval lastTime;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UIButton *checkSet;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *inputText;
@property (weak, nonatomic) IBOutlet UIButton *closeKB;
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UIView *subFuncView;

@property (strong, nonatomic)NSDictionary *dicNet;

@end
int count;
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.checkSet addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn addTarget:self action:@selector(leftLongClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.inputText addTarget:self action:@selector(startInputText) forControlEvents:UIControlEventTouchUpInside];
    [self.closeKB addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    [[UDPManage shareUDPManage]receiveBlock:^(NSString *ip, uint16_t port, id mes) {
        
        NSLog(@"收到服务端的响应 [%@:%d] %@", ip, port, mes);
        NSDictionary *dic = [self dictionaryWithJsonString:mes];
        if([dic[@"action"] isEqualToString: @"receive"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.showName.text = dic[@"value"];
                self.dicNet = @{@"ip":ip,@"port":@(port)};
            });
        }
    }];

    self.imageV.hidden = NO;
    self.textInput.delegate = self;
    [self addGesture];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"点击了确认");
    [self confirmInputText];
    [self cleanText];
    [self closeKeyboard];
    return YES;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (void)check
{
    self.subFuncView.hidden = !self.subFuncView.hidden;
    self.showName.text = @"check";
    [[UDPManage shareUDPManage]checkAset];
}

- (void)cleanText
{
    self.textInput.text = @"";
}

- (void)confirmInputText
{
    if (!_dicNet) return;
    if (!self.textInput.text||[self.textInput.text isEqualToString:@""])return;
    NSLog(@"双击");
    NSDictionary *dic =
    @{@"action":@"keyboardInput",
      @"value":self.textInput.text
      };
    [[UDPManage shareUDPManage]sendMessage:dic ipHost:_dicNet[@"ip"] port:[_dicNet[@"port"]intValue]];
}

- (void)startInputText
{
    self.textInput.hidden = NO;
    [self.textInput becomeFirstResponder];
}

- (void)closeKeyboard
{
    self.textInput.hidden = YES;
    [self.textInput resignFirstResponder];
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

- (void)leftLongClick
{
    if (!_dicNet) return;
//    NSDictionary *dic = nil;
    if (self.leftBtn.tag == 0) {
        NSLog(@"按下");
        self.leftBtn.tag = 1;
//        dic =
//        @{@"action":@"leftClickDown",
//          };
        self.leftBtn.backgroundColor = [UIColor grayColor];
    }else{
        NSLog(@"松起");
        self.leftBtn.tag = 0;
//        dic =
//        @{@"action":@"leftClickUp",
//          };
        self.leftBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
//    [[UDPManage shareUDPManage]sendMessage:dic ipHost:_dicNet[@"ip"] port:[_dicNet[@"port"]intValue]];
}

- (void)rightClick
{
    
    if (!_dicNet) return;
    NSLog(@"右击");
    NSDictionary *dic =
    @{@"action":@"rightClick",
      };
    [[UDPManage shareUDPManage]sendMessage:dic ipHost:_dicNet[@"ip"] port:[_dicNet[@"port"]intValue]];
}

- (void)singleTap:(UITapGestureRecognizer *)singleTap
{
    if (!_dicNet) return;
    NSLog(@"单击");
    NSDictionary *dic =
    @{@"action":@"mouseSingleClick",
      };
    [[UDPManage shareUDPManage]sendMessage:dic ipHost:_dicNet[@"ip"] port:[_dicNet[@"port"]intValue]];
}
- (void)doubleTap:(UITapGestureRecognizer *)doubleTap
{
    if (!_dicNet) return;
    NSLog(@"双击");
    NSDictionary *dic =
    @{@"action":@"mouseDoubleClick",
      };
    [[UDPManage shareUDPManage]sendMessage:dic ipHost:_dicNet[@"ip"] port:[_dicNet[@"port"]intValue]];
}


#pragma mark - touch开始的时候
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch=[touches anyObject];
//    if (touch.view != self.touchBg) return;
    
    CGPoint current=[touch locationInView:self.view];
    _imageV.center=CGPointMake(current.x, current.y);
    
    _lastTime = 0;
}

//#pragma mark--touch移动中
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!_dicNet) return;
    UITouch *touch = [touches anyObject];
    //取得当前位置
    CGPoint current=[touch preciseLocationInView:self.view];//
    //取得前一个位置
    CGPoint previous=[touch precisePreviousLocationInView:self.view];
    
    //移动前的中点位置
    CGPoint center=_imageV.center;
    //移动偏移量
    CGPoint offset=CGPointMake(current.x-previous.x, current.y-previous.y);
    if (offset.x == 0&&offset.y == 0) return;
    
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
    
    NSDictionary *dic = nil;
    if (self.leftBtn.tag == 0) {
        dic =
        @{@"action":@"mouseMove",
          @"value":@{@"x":@(offset.x),@"y":@(offset.y),@"k":@(k)
                     },
          };
    }else if (self.leftBtn.tag == 1){
        dic =
        @{@"action":@"mousePressMove",
          @"value":@{@"x":@(offset.x),@"y":@(offset.y),@"k":@(k)
                     },
          };
    }
    [[UDPManage shareUDPManage]sendMessage:dic ipHost:_dicNet[@"ip"] port:[_dicNet[@"port"]intValue]];
}


//#pragma mark--touch移动结束
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



#pragma mark - else

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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}

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



@end
