//
//  GJTDebugerBaseViewController.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import "GJTDebugerBaseViewController.h"
#import "GJTDebugerStatusBar.h"
#import "GJTDebugerNavBarItemModel.h"
#import <GJTAdditionKit/GJTAdditionKit.h>
#import "GJTDebugerDefine.h"
#import "GJTDebugerNavBarItemModel.h"
#import "GJTDebugerHomeWindow.h"
#import "UIImage+GJTDebuger.h"

#import "GJTDebugerAppInfoUtil.h"

#define IS_IPHONE_X_Series [GJTDebugerAppInfoUtil isIPhoneXSeries]
#define IPHONE_NAVIGATIONBAR_HEIGHT  0
#define IPHONE_STATUSBAR_HEIGHT      (IS_IPHONE_X_Series ? 44 : 20)
#define IPHONE_SAFEBOTTOMAREA_HEIGHT (IS_IPHONE_X_Series ? 34 : 0)
#define IPHONE_TOPSENSOR_HEIGHT      (IS_IPHONE_X_Series ? 32 : 0)


@interface GJTDebugerBaseViewController ()<GJTDebugerBaseBigTitleViewDelegate>

@end

@implementation GJTDebugerBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self needBigTitleView]) {
        if ([GJTDebugerStatusBar shareInstance].hidden) {
            _bigTitleView = [[GJTDebugerBaseBigTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.gjt_width, kDebugerSizeFrom750_Landscape(178))];
        }else{
            _bigTitleView = [[GJTDebugerBaseBigTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.gjt_width, kDebugerSizeFrom750_Landscape(178)+IPHONE_STATUSBAR_HEIGHT)];
        }
        _bigTitleView.delegate = self;
        [self.view addSubview:_bigTitleView];
    }else{
        GJTDebugerNavBarItemModel *leftModel = [[GJTDebugerNavBarItemModel alloc] initWithImage:[UIImage debuger_imageNamed:@"doraemon_back"] selector:@selector(leftNavBackClick:)];
        [self setLeftNavBarItems:@[leftModel]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = [self needBigTitleView];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //输入框聚焦的时候，会把当前window设置为keyWindow，我们在当页面消失的时候，判断一下，把keyWindow交还给[[UIApplication sharedApplication].delegate window]
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (appWindow != keyWindow) {
        [appWindow makeKeyWindow];
    }
}

//是否需要大标题，默认不需要
- (BOOL)needBigTitleView{
    return NO;
}

- (void)setTitle:(NSString *)title{
    if (_bigTitleView && !_bigTitleView.hidden) {
        [_bigTitleView setTitle:title];
    }else{
        [super setTitle:title];
    }
}

- (void)leftNavBackClick:(id)clickView{
    if (self.navigationController.viewControllers.count==1) {
        [[GJTDebugerHomeWindow shareInstance] hide];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)setLeftNavBarItems:(NSArray *)items{
    NSArray *barItems = [self navigationItems:items];
    if (barItems) {
        self.navigationItem.leftBarButtonItems = barItems;
    }
}

- (NSArray *)navigationItems:(NSArray *)items{
    NSMutableArray *barItems = [NSMutableArray array];
    //距离左右的间距
    UIBarButtonItem *spacer = [self getSpacerByWidth:-10];
    [barItems addObject:spacer];
    
    for (int i=0; i<items.count; i++) {
        
        GJTDebugerNavBarItemModel *model = items[i];
        UIBarButtonItem *barItem;
        if (model.type == GJTDebugerNavBarItemTypeText) {//文字按钮
            barItem = [[UIBarButtonItem alloc] initWithTitle:model.text style:UIBarButtonItemStylePlain target:self action:model.selector];
            barItem.tintColor = model.textColor;
        }else if(model.type == GJTDebugerNavBarItemTypeImage){//图片按钮
            UIImage *image = [model.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//设置图片没有默认蓝色效果
            //默认的间距太大
            //            barItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:model.selector];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:image forState:UIControlStateNormal];
            [btn addTarget:self action:model.selector forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, 0, 30, 30);
            btn.clipsToBounds = YES;
            barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
        [barItems addObject:barItem];
    }
    return barItems;
}

/**
 * 获取间距
 */
- (UIBarButtonItem *)getSpacerByWidth : (CGFloat)width{
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    spacer.width = width;
    return spacer;
}

#pragma mark - DoraemonBaseBigTitleViewDelegate
- (void)bigTitleCloseClick{
    [self leftNavBackClick:nil];
}

//点击屏幕空白处收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
