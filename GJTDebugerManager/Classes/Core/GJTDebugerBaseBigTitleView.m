//
//  GJTDebugerBaseBigTitleView.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import "GJTDebugerBaseBigTitleView.h"
#import "GJTDebugerStatusBar.h"
#import <GJTAdditionKit/GJTAdditionKit.h>
#import "GJTDebugerDefine.h"
#import "UIImage+GJTDebuger.h"
#import "GJTDebugerAppInfoUtil.h"

#define IS_IPHONE_X_Series [GJTDebugerAppInfoUtil isIPhoneXSeries]
#define IPHONE_NAVIGATIONBAR_HEIGHT  0
#define IPHONE_STATUSBAR_HEIGHT      (IS_IPHONE_X_Series ? 44 : 20)
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_IPHONE_X_Series ? 34 : 0)
#define IPHONE_TOPSENSOR_HEIGHT      (IS_IPHONE_X_Series ? 32 : 0)

@interface GJTDebugerBaseBigTitleView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *downLine;

@end

@implementation GJTDebugerBaseBigTitleView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat offsetY = 0;
        if (![GJTDebugerStatusBar shareInstance].hidden) {
            offsetY = IPHONE_STATUSBAR_HEIGHT;
        }
        CGFloat titleLabelOffsetY = offsetY + ((self.gjt_height-offsetY)/2-kDebugerSizeFrom750_Landscape(67)/2);
        CGFloat closeBtnH = self.gjt_height-offsetY;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDebugerSizeFrom750_Landscape(32), titleLabelOffsetY, self.gjt_width-kDebugerSizeFrom750_Landscape(32)-closeBtnH, kDebugerSizeFrom750_Landscape(67))];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#324456"];
        _titleLabel.font = [UIFont systemFontOfSize:kDebugerSizeFrom750_Landscape(48)];
        [self addSubview:_titleLabel];
        
        
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.gjt_width-closeBtnH, offsetY, closeBtnH, closeBtnH)];
        _closeBtn.imageView.contentMode = UIViewContentModeCenter;
        [_closeBtn setImage:[UIImage debuger_imageNamed:@"doraemon_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        _downLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.gjt_height-kDebugerSizeFrom750_Landscape(1), self.gjt_width, kDebugerSizeFrom750_Landscape(1))];
//        _downLine.backgroundColor = [UIColor colorWithHexString@"0x000000" andAlpha:0.1];
        _downLine.backgroundColor = [UIColor colorWithHexString:@"0x000000"];
        [self addSubview:_downLine];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = _title;
}

- (void)closeClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bigTitleCloseClick)]) {
        [self.delegate bigTitleCloseClick];
    }
}

@end
