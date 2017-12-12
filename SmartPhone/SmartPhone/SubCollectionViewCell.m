//
//  SubCollectionViewCell.m
//  SmartPhone
//
//  Created by 李杰 on 2017/12/12.
//  Copyright © 2017年 Jack. All rights reserved.
//

#import "SubCollectionViewCell.h"

@interface SubCollectionViewCell ()
@property (nonatomic, strong) UILabel *labTitle;
@end

@implementation SubCollectionViewCell
//{
//    UILabel *labTitle;
//}

- (void)setText:(NSString *)text
{
    _text = text;
    self.labTitle.text = _text;
    
}

- (UILabel *)labTitle
{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.font = [UIFont systemFontOfSize:13];
        [self addSubview:_labTitle];
    }
    return _labTitle;
}

@end
