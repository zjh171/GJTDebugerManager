//
//  GJTDebugScanningViewController.m
//  GJTSettingModule
//
//  Created by kyson on 2021/3/15.
//

#import "GJTDebugScanningViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
//#import <GJTMvvmKit/GJTMvvmKit.h>
#import "GJTDebugerManager.h"
#import <GJTAdditionKit/GJTAdditionKit.h>

//#import <GJTFoundation/GJTFoundation.h>
#import "GJTDebugerQRCodeTool.h"

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface GJTDebugScanningViewController () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) GJTDebugerQRCodeTool *qrcode;

@end

@implementation GJTDebugScanningViewController


- (void)createCode {
    WEAKSELF(weakSelf)
    self.qrcode = [GJTDebugerQRCodeTool shared];
    [self.qrcode QRCodeDeviceInitWithVC:self WithQRCodeWidth:0 ScanResults:^(NSString *result) {
        [weakSelf.qrcode stopScanning];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [GJTDebugerManager shareInstance].H5EntranceBlock(result);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Debug - 扫一扫";

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                NSLog(@"用户允许");
                [self createCode];

                [self.qrcode startScanning];
            }else{
                //用户拒绝
                NSLog(@"用户拒绝");
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].width, [UIScreen mainScreen].height);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
}


@end
