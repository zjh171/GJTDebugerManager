//
//  GJTInputToolBar.h
//  GJTControlsKit
//
//  Created by kyson on 2021/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^inputToolBarSendBlock)(NSString *text);

@interface GJTInputToolBar : UIView
/*显示遮罩*/
@property (nonatomic, assign) BOOL showMaskView;
/**设置输入框最大行数*/
@property (nonatomic, assign) NSInteger textViewMaxLine;
/**输入框文字大小*/
@property (nonatomic, assign) CGFloat fontSize;
/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;
/*输入的文字*/
@property (nonatomic, readonly, copy) NSString *inputText;
/**弹出键盘*/
- (void)showToolbar;
/**收回键盘*/
- (void)dissmissToolbar;
/**清空文字*/
- (void)clearText;
/**点击发送按钮*/
- (void)inputToolbarSendText:(inputToolBarSendBlock)sendBlock;


@end
NS_ASSUME_NONNULL_END

