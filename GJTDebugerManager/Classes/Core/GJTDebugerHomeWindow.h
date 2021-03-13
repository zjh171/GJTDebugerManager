//
//  GJTDebugerHomeWindow.h
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJTDebugerHomeWindow : UIWindow



@property (nonatomic, strong) UINavigationController *nav;

+ (GJTDebugerHomeWindow *)shareInstance;

- (void)openPlugin:(UIViewController *)vc;

- (void)show;

- (void)hide;


@end

NS_ASSUME_NONNULL_END
