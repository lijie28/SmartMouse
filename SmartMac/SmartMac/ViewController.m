//
//  ViewController.m
//  SmartMac
//
//  Created by 李杰 on 2018/2/2.
//  Copyright © 2018年 李杰. All rights reserved.
//

#import "ViewController.h"
#import <AppKit/AppKit.h>

@interface ViewController ()
/** <#name#> */
@property (nonatomic, strong) NSStatusItem *demoItem;
/** <#name#> */
@property (nonatomic, strong) NSPopover *popover;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.demoItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.demoItem.button setImage:[NSImage imageNamed:@"yes"]];
    
    
////    popover弹窗
//    _popover = [[NSPopover alloc]init];
//    _popover.behavior = NSPopoverBehaviorTransient;
//    _popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
//
//    self.demoItem.target = self;
//    self.demoItem.button.action = @selector(showMyPopover:);
    
    
    
//    //获取主目录
//    NSMenu *mainMenu = [NSApp mainMenu];
//    NSLog(@"%@ - %@",mainMenu,[mainMenu itemArray]);
//
//    //添加一级目录
//    NSMenuItem *oneItem = [[NSMenuItem alloc] init];
//    [oneItem setTitle:@"Load_TEXT"];
//    [mainMenu addItem:oneItem];
    
    //添加二级目录项
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@"Load_TEXT"];
    
    [subMenu addItemWithTitle:@"Load1"action:@selector(load1) keyEquivalent:@"E"];
    [subMenu addItemWithTitle:@"Load2"action:@selector(load2) keyEquivalent:@"R"];
    
//    [oneItem setSubmenu:subMenu];
    self.demoItem.menu = subMenu;
}

- (void)load1
{
    NSLog(@"load1");
}
- (void)load2
{
    NSLog(@"load2");
}

- (void)showMyPopover:(NSStatusBarButton *)button
{
    [_popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSRectEdgeMaxY];
}



@end
