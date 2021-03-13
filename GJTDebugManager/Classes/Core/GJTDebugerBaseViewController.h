//
//  GJTDebugerBaseViewController.h
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import <UIKit/UIKit.h>
#import "GJTDebugerBaseBigTitleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GJTDebugerBaseViewController : UIViewController

@property (nonatomic, strong) GJTDebugerBaseBigTitleView *bigTitleView;

//是否需要大标题，默认不需要
- (BOOL)needBigTitleView;

- (void)setLeftNavBarItems:(NSArray *)items;
- (void)leftNavBackClick:(id)clickView;


@end

NS_ASSUME_NONNULL_END
