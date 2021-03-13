//
//  GJTDebugerEntryView.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import "GJTDebugerEntryView.h"
#import "GJTDebugerStatusBarViewController.h"
#import "GJTDebugerDefine.h"
#import "GJTDebugerDefine.h"
#import "GJTDebugerHomeWindow.h"
#import "UIImage+GJTDebuger.h"
#import <GJTAdditionKit/GJTAdditionKit.h>

@interface GJTDebugerEntryView()

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIButton *entryBtn;
@property (nonatomic, assign) CGFloat kEntryViewSize;

@end


@implementation GJTDebugerEntryView



- (instancetype)init{
    _kEntryViewSize = 58;
    self = [super initWithFrame:CGRectMake(0, GJTDebugerScreenHeight/3, _kEntryViewSize, _kEntryViewSize)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100.f;
        self.layer.masksToBounds = YES;
        NSString *version= [UIDevice currentDevice].systemVersion;
        if(version.doubleValue >=10.0) {
            if (!self.rootViewController) {
                self.rootViewController = [[UIViewController alloc] init];
            }
        }else{
            //iOS9.0的系统中，新建的window设置的rootViewController默认没有显示状态栏
            if (!self.rootViewController) {
                self.rootViewController = [[GJTDebugerStatusBarViewController alloc] init];
            }
        }
        
        UIButton *entryBtn = [[UIButton alloc] initWithFrame:self.bounds];
        entryBtn.backgroundColor = [UIColor clearColor];
        [entryBtn setImage:[UIImage debuger_imageNamed:@"debuger_logo"] forState:UIControlStateNormal];
        entryBtn.layer.cornerRadius = 20.;
        [entryBtn addTarget:self action:@selector(entryClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rootViewController.view addSubview:entryBtn];
        _entryBtn = entryBtn;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)showClose:(NSNotification *)notification{
    [_entryBtn setImage:[UIImage debuger_imageNamed:@"debuger_close"] forState:UIControlStateNormal];
    [_entryBtn removeTarget:self action:@selector(showClose:) forControlEvents:UIControlEventTouchUpInside];
    [_entryBtn addTarget:self action:@selector(closePluginClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closePluginClick:(UIButton *)btn{
    [_entryBtn setImage:[UIImage debuger_imageNamed:@"debuger_logo"] forState:UIControlStateNormal];
    [_entryBtn removeTarget:self action:@selector(closePluginClick:) forControlEvents:UIControlEventTouchUpInside];
    [_entryBtn addTarget:self action:@selector(entryClick:) forControlEvents:UIControlEventTouchUpInside];
//    [[NSNotificationCenter defaultCenter] postNotificationName:DoraemonClosePluginNotification object:nil userInfo:nil];
}

//不能让该View成为keyWindow，每一次它要成为keyWindow的时候，都要将appDelegate的window指为keyWindow
- (void)becomeKeyWindow{
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}

/**
 进入工具主面板
 */
- (void)entryClick:(UIButton *)btn {
    if ([GJTDebugerHomeWindow shareInstance].hidden) {
        [[GJTDebugerHomeWindow shareInstance] show];
    } else {
        [[GJTDebugerHomeWindow shareInstance] hide];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:DoraemonClosePluginNotification object:nil userInfo:nil];
}

- (void)pan:(UIPanGestureRecognizer *)sender{
    //1、获得拖动位移
    CGPoint offsetPoint = [sender translationInView:sender.view];
    //2、清空拖动位移
    [sender setTranslation:CGPointZero inView:sender.view];
    //3、重新设置控件位置
    UIView *panView = sender.view;
    CGFloat newX = panView.gjt_centerX+offsetPoint.x;
    CGFloat newY = panView.gjt_centerY+offsetPoint.y;
    if (newX < _kEntryViewSize/2) {
        newX = _kEntryViewSize/2;
    }
    if (newX > GJTDebugerScreenWidth - _kEntryViewSize/2) {
        newX = GJTDebugerScreenWidth - _kEntryViewSize/2;
    }
    if (newY < _kEntryViewSize/2) {
        newY = _kEntryViewSize/2;
    }
    if (newY > GJTDebugerScreenHeight - _kEntryViewSize/2) {
        newY = GJTDebugerScreenHeight - _kEntryViewSize/2;
    }
    panView.center = CGPointMake(newX, newY);
}


@end
