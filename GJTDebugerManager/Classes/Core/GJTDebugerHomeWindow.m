//
//  GJTDebugerHomeWindow.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import "GJTDebugerHomeWindow.h"
#import "GJTDebugerDefine.h"
#import "GJTDebugerHomeViewController.h"

@implementation GJTDebugerHomeWindow

+ (GJTDebugerHomeWindow *)shareInstance{
    static dispatch_once_t once;
    static GJTDebugerHomeWindow *instance;
    dispatch_once(&once, ^{
        instance = [[GJTDebugerHomeWindow alloc] initWithFrame:CGRectMake(0, 0, GJTDebugerScreenWidth, GJTDebugerScreenHeight)];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1.f;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

- (void)openPlugin:(UIViewController *)vc{
    [self setRootVc:vc];
     self.hidden = NO;
}

- (void)show {
    GJTDebugerHomeViewController *vc = [[GJTDebugerHomeViewController alloc] init];
    [self setRootVc:vc];
    
    self.hidden = NO;
}

- (void)hide{
    [self setRootVc:nil];
    
    self.hidden = YES;
}

- (void)setRootVc:(UIViewController *)rootVc{
    if (rootVc) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVc];
        NSDictionary *attributesDic = @{
                                        NSForegroundColorAttributeName:[UIColor blackColor],
                                        NSFontAttributeName:[UIFont systemFontOfSize:18]
                                        };
        [nav.navigationBar setTitleTextAttributes:attributesDic];
        _nav = nav;
        
        self.rootViewController = nav;
    }else{
        self.rootViewController = nil;
        _nav = nil;
    }

}

@end
