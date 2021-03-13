//
//  GJTDebugerStatusBar.m
//  AFNetworking
//
//  Created by kyson on 2021/3/22.
//

#import "GJTDebugerStatusBar.h"
#import <GJTAdditionKit/GJTAdditionKit.h>
#import "GJTDebugerDefine.h"



#import "GJTDebugerAppInfoUtil.h"

#define IS_IPHONE_X_Series [GJTDebugerAppInfoUtil isIPhoneXSeries]
#define IPHONE_NAVIGATIONBAR_HEIGHT  0
#define IPHONE_STATUSBAR_HEIGHT      (IS_IPHONE_X_Series ? 44 : 20)
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_IPHONE_X_Series ? 34 : 0)
#define IPHONE_TOPSENSOR_HEIGHT      (IS_IPHONE_X_Series ? 32 : 0)

@interface GJTDebugerStatusBar ()


@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) GJTDebugerStatesBarFrom from;

@end

@implementation GJTDebugerStatusBar

+ (GJTDebugerStatusBar *)shareInstance{
    static dispatch_once_t once;
    static GJTDebugerStatusBar *instance;
    dispatch_once(&once, ^{
        instance = [[GJTDebugerStatusBar alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1.f;
        self.backgroundColor = [UIColor colorWithHexString:@"#427dbe"];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:kDebugerSizeFrom750_Landscape(20)];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_contentLabel];
        
        _contentLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
        [_contentLabel addGestureRecognizer:tap];
    }
    return self;
}

- (void)becomeKeyWindow{
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}

- (void)show{
    self.hidden = NO;
    self.frame = CGRectMake(0, 0, GJTDebugerScreenWidth, IPHONE_STATUSBAR_HEIGHT);
    if(IS_IPHONE_X_Series){
        _contentLabel.frame = CGRectMake(0, self.gjt_height-20, GJTDebugerScreenWidth, 20);
    }else{
        _contentLabel.frame = CGRectMake(0, 0, GJTDebugerScreenWidth, IPHONE_STATUSBAR_HEIGHT);
    }
}

- (void)hide{
    self.hidden = YES;
}

- (void)renderUIWithContent:(NSString *)content from:(GJTDebugerStatesBarFrom)from{
    _contentLabel.text = content;
    _from = from;
}

- (void)tapView{
//    [[NSNotificationCenter defaultCenter] postNotificationName:DoraemonQuickOpenLogVCNotification object:nil userInfo:@{@"from":@(_from)}];
}



@end
