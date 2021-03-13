//
//  GJTDebugerHomeViewController.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import "GJTDebugerHomeViewController.h"
#import <GJTAdditionKit/GJTAdditionKit.h>
#import "GJTDebugerDefine.h"
#import "GJTDebugerHomeSectionView.h"
#import "GJTDebugerManager.h"
#import "GJTDebugerHomeWindow.h"

@interface GJTDebugerHomeViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation GJTDebugerHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initData{
    _dataArray = [GJTDebugerManager shareInstance].dataArray;
}

- (void)initUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    
    CGFloat offsetY = kDebugerSizeFrom750_Landscape(32);
    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *itemData = _dataArray[i];
        CGFloat sectionHeight = [GJTDebugerHomeSectionView viewHeightWithData:itemData];
        GJTDebugerHomeSectionView *sectionView = [[GJTDebugerHomeSectionView alloc] initWithFrame:CGRectMake(kDebugerSizeFrom750_Landscape(16), offsetY, self.view.gjt_width-kDebugerSizeFrom750_Landscape(16)*2, sectionHeight)];
        sectionView.tag = GJT_debuger_scrollViewTagStartSubscript + i;
        [sectionView renderUIWithData:itemData];
        [_scrollView addSubview:sectionView];
        offsetY += sectionHeight+kDebugerSizeFrom750_Landscape(32);
    }
    
    offsetY = offsetY - kDebugerSizeFrom750_Landscape(32) + kDebugerSizeFrom750_Landscape(56);
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDebugerSizeFrom750_Landscape(30), offsetY, self.view.gjt_width-2*kDebugerSizeFrom750_Landscape(30), kDebugerSizeFrom750_Landscape(100))];
    closeBtn.tag = GJT_debuger_scrollViewTagStartSubscript + _dataArray.count;
    closeBtn.backgroundColor = [UIColor whiteColor];
    [closeBtn setTitle:@"关闭Debuger" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithHexString:@"#CC3A4B"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:closeBtn];
    
    offsetY += closeBtn.gjt_height+kDebugerSizeFrom750_Landscape(30);
    
    _scrollView.contentSize = CGSizeMake(self.view.gjt_width, offsetY);
}

- (void)close{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"Doraemon关闭之后需要重启App才能重新打开" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[GJTDebugerManager shareInstance] hiddenDoraemon];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
//    [[DoraemonUtil topViewControllerForKeyWindow] presentViewController:alertController animated:YES completion:nil];
    
    [[GJTDebugerHomeWindow shareInstance] hide];
}


int GJT_debuger_scrollViewTagStartSubscript = 10;
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    // 屏幕旋转时更新 scrollView 及其子视图 frame
    if (_scrollView) {
        _scrollView.frame = [UIScreen mainScreen].bounds;
        CGFloat offsetY = kDebugerSizeFrom750_Landscape(32);
        for (int i = 0; i < _dataArray.count; i++) {
            NSDictionary *itemData = _dataArray[i];
            CGFloat sectionHeight = [GJTDebugerHomeSectionView viewHeightWithData:itemData];
            GJTDebugerHomeSectionView *sectionView = [_scrollView viewWithTag:GJT_debuger_scrollViewTagStartSubscript + i];
            sectionView.frame = CGRectMake(kDebugerSizeFrom750_Landscape(16), offsetY, GJTDebugerScreenWidth - kDebugerSizeFrom750_Landscape(16) * 2, sectionHeight);
            [sectionView updateUILayoutWithData:itemData];
            offsetY += sectionHeight + kDebugerSizeFrom750_Landscape(32);
        }
        
        [_scrollView viewWithTag:GJT_debuger_scrollViewTagStartSubscript + _dataArray.count].frame = CGRectMake(kDebugerSizeFrom750_Landscape(30), offsetY, GJTDebugerScreenWidth - 2 * kDebugerSizeFrom750_Landscape(30), kDebugerSizeFrom750_Landscape(100));
        offsetY += kDebugerSizeFrom750_Landscape(100) + kDebugerSizeFrom750_Landscape(30);
        _scrollView.contentSize = CGSizeMake(GJTDebugerScreenWidth, offsetY);
    }
}

@end
