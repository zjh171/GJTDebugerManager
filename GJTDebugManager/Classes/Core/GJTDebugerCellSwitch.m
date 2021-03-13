//
//  GJTDebugerCellSwitch.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/19.
//  Copyright © 2020 me.ele. All rights reserved.
//

#import "GJTDebugerCellSwitch.h"
#import "GJTDebugerDefine.h"
#import <GJTAdditionKit/GJTAdditionKit.h>

@interface GJTDebugerCellSwitch ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *downLine;

@end


@implementation GJTDebugerCellSwitch


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:kDebugerSizeFrom750_Landscape(32)];
        [self addSubview:_titleLabel];
        
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = [UIColor colorWithHexString:@"337CC4"];
        [_switchView addTarget:self action:@selector(switchChange:)forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switchView];
        
        _topLine = [[UIView alloc] init];
        _topLine.hidden = YES;
        _topLine.backgroundColor = [UIColor colorWithHexString:@"000000"];
        _topLine.alpha = 0.1f;
        [self addSubview:_topLine];
        
        _downLine = [[UIView alloc] init];
        _downLine.hidden = YES;
        _downLine.backgroundColor = [UIColor colorWithHexString:@"000000"];
        _downLine.alpha = 0.1f;
        
        [self addSubview:_downLine];
    }
    return self;
}

- (void)renderUIWithTitle:(NSString *)title switchOn:(BOOL)on{
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(20, self.gjt_height/2-_titleLabel.gjt_height/2, _titleLabel.gjt_width, _titleLabel.gjt_height);
    
    _switchView.on = on;
    _switchView.frame = CGRectMake(self.gjt_width-20-_switchView.gjt_width, self.gjt_height/2-_switchView.gjt_height/2, _switchView.gjt_width, _switchView.gjt_height);
}

- (void)needTopLine{
    _topLine.hidden = NO;
    _topLine.frame = CGRectMake(0, 0, self.gjt_width, 0.5);
}

- (void)needDownLine{
    _downLine.hidden = NO;
    _downLine.frame = CGRectMake(0, self.gjt_height-0.5, self.gjt_width, 0.5);
}

- (void)switchChange:(UISwitch*)sender{
    BOOL on = sender.on;
    if (_delegate && [_delegate respondsToSelector:@selector(changeSwitchOn:sender:)]) {
        [_delegate changeSwitchOn:on sender:sender];
    }
}

@end
