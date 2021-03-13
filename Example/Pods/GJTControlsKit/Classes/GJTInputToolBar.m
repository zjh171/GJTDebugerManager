//
//  GJTInputToolBar.m
//  GJTControlsKit
//
//  Created by kyson on 2021/2/27.
//

#import "GJTInputToolBar.h"
#import <GJTAdditionKit/GJTAdditionKit.h>

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface GJTInputToolBar ()<UITextViewDelegate>

/**遮罩*/
@property (nonatomic, strong) UIView *maskView;
/**背景*/
@property (nonatomic, strong) UIView *backgroundView;
/**文本输入框*/
@property (nonatomic, strong) UITextView *textView;
/**边框*/
@property (nonatomic, strong) UIView *edgeLineView;
/**顶部线条*/
@property (nonatomic, strong) UIView *topLine;
/**底部线条*/
@property (nonatomic, strong) UIView *bottomLine;
/**textView占位符*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/**发送按钮*/
@property (nonatomic, strong) UIButton *sendButton;
/*keyWindow*/
@property (nonatomic, strong) UIWindow *keyWindow;
/**发送回调*/
@property (nonatomic, copy) inputToolBarSendBlock sendBlock;

@end

@implementation GJTInputToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0,0, UIScreen.width, 50);
    //顶部线条
    [self addSubview:self.topLine];
    //底部线条
    [self addSubview:self.bottomLine];
    //边框
    [self addSubview:self.edgeLineView];
    //输入框
    [self addSubview:self.textView];
    //占位文字
    [self addSubview:self.placeholderLabel];
    //发送按钮
    [self addSubview:self.sendButton];
    self.fontSize = 20;
    self.textViewMaxLine = 3;
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    if (!fontSize || _fontSize < 16) {
        _fontSize = 16;
    }
    self.textView.font = [UIFont systemFontOfSize:_fontSize];
    self.placeholderLabel.font = self.textView.font;
    CGFloat lineH = self.textView.font.lineHeight;
    self.gjt_height = ceil(lineH) + 10 + 10;
    self.textView.gjt_height = lineH;
}
- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine {
    _textViewMaxLine = textViewMaxLine;
    if (!_textViewMaxLine || _textViewMaxLine <= 0) {
        _textViewMaxLine = 3;
    }
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length;
    if (textView.text.length == 0) {
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    }else{
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:RGBACOLOR(0, 0, 0, 1.0) forState:UIControlStateNormal];
    }
    CGFloat contentSizeH = textView.contentSize.height;
    CGFloat lineH = textView.font.lineHeight;
    CGFloat maxTextViewHeight = ceil(lineH * self.textViewMaxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxTextViewHeight) {
        textView.gjt_height = contentSizeH;
    }else{
        textView.gjt_height = maxTextViewHeight;
    }
    
    CGFloat newHeight = ceil(textView.gjt_height) + 10 + 10;
    CGFloat change = newHeight - self.gjt_height;
    if (change != 0) {
        self.gjt_height = newHeight;
        self.gjt_top = self.gjt_top - change;
    }
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}
- (void)tapActions:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dissmissToolbar];
}
- (NSString *)inputText {
    return self.textView.text;
}
// 发送按钮
-(void)didClicksendButton {
    if (self.sendBlock) {
        self.sendBlock(self.textView.text);
    }
}
- (void)inputToolbarSendText:(inputToolBarSendBlock)sendBlock{
    self.sendBlock = sendBlock;
}
- (void)showToolbar{
    if (_showMaskView) {
        [self.keyWindow addSubview:self.maskView];
    }
    [self.keyWindow addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.textView];
    [self.textView becomeFirstResponder];
}
-(void)dissmissToolbar {
//    self.textView.text = nil;
    [self.textView.delegate textViewDidChange:self.textView];
    [self.textView resignFirstResponder];
    [self.backgroundView removeFromSuperview];
    if (_showMaskView) {
        [self.maskView removeFromSuperview];
    }
}
- (void)clearText {
    self.textView.text = nil;
    [self.textView.delegate textViewDidChange:self.textView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.maskView.gjt_size = CGSizeMake(UIScreen.width, UIScreen.height);
    self.gjt_width = UIScreen.width;
    self.topLine.gjt_left = 0;
    self.topLine.gjt_top = 0;
    self.topLine.gjt_width = self.gjt_width;
    self.topLine.gjt_height = 1;
    
    self.bottomLine.gjt_left = 0;
    self.bottomLine.gjt_bottom = 0;
    self.bottomLine.gjt_width = self.gjt_width;
    self.bottomLine.gjt_height = 1;
    
    self.edgeLineView.gjt_height = self.textView.gjt_height + 10;
    self.edgeLineView.gjt_width = self.gjt_width - 50 - 30;
    self.edgeLineView.gjt_left = 10;
    
    self.textView.gjt_width = self.gjt_width - 50 - 46;
    self.textView.gjt_left = 18;
    
    self.placeholderLabel.gjt_width = self.textView.gjt_width - 10;
    self.placeholderLabel.gjt_left = 23;
    self.placeholderLabel.gjt_height = self.textView.gjt_height;
    
    self.sendButton.gjt_right = self.gjt_width - 10;
    self.sendButton.gjt_width = 50;
    self.sendButton.gjt_height = 30;
    
    CGFloat contentSizeH = self.textView.contentSize.height;
    CGFloat lineH = self.textView.font.lineHeight;
    CGFloat maxTextViewHeight = ceil(lineH * self.textViewMaxLine + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    if (contentSizeH <= maxTextViewHeight) {
        self.textView.gjt_height = contentSizeH;
    }else{
        self.textView.gjt_height = maxTextViewHeight;
    }
    
    CGFloat newHeight = ceil(self.textView.gjt_height) + 10 + 10;
    CGFloat change = newHeight - self.gjt_height;
    if (change != 0) {
        self.gjt_height = newHeight;
        self.gjt_top = self.gjt_top - change;
    }
    
    self.edgeLineView.gjt_centerY = self.gjt_height * 0.5;
    self.placeholderLabel.gjt_centerY = self.gjt_height * 0.5;
    self.sendButton.gjt_centerY = self.gjt_height * 0.5;
    self.backgroundView.frame = [self convertRect:self.bounds toView:self.keyWindow];
    self.textView.gjt_centerY = self.backgroundView.gjt_height * 0.5;
}
//MARK:JmoVxia---懒加载
- (UIView *) maskView{
    if (_maskView == nil){
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor lightGrayColor];
        _maskView.alpha = 0.5;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
        [_maskView addGestureRecognizer:tapGestureRecognizer];
    }
    return _maskView;
}
- (UIView *) backgroundView{
    if (_backgroundView == nil){
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}
- (UIView *) topLine{
    if (_topLine == nil){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    }
    return _topLine;
}
- (UIView *) bottomLine{
    if (_bottomLine == nil){
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    }
    return _bottomLine;
}
- (UIView *) edgeLineView{
    if (_edgeLineView == nil){
        _edgeLineView = [[UIView alloc]init];
        _edgeLineView.layer.cornerRadius = 5;
        _edgeLineView.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
        _edgeLineView.layer.borderWidth = 1;
        _edgeLineView.layer.masksToBounds = YES;
    }
    return _edgeLineView;
}
- (UITextView *) textView{
    if (_textView == nil){
        _textView = [[UITextView alloc] init];
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textColor = [UIColor blackColor];
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.scrollsToTop = NO;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.inputAccessoryView = self;
    }
    return _textView;
}
- (UILabel *)placeholderLabel{
    if (_placeholderLabel == nil){
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = RGBACOLOR(0, 0, 0, 0.5);
    }
    return _placeholderLabel;
}
- (UIButton *) sendButton{
    if (_sendButton == nil){
        _sendButton = [[UIButton alloc] init];
        _sendButton.layer.borderWidth = 1.0;
        _sendButton.layer.cornerRadius = 5.0;
        _sendButton.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
        _sendButton.enabled = NO;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(didClicksendButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (UIWindow *) keyWindow{
    if (_keyWindow == nil){
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _keyWindow;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (CGRectContainsPoint(self.textView.frame, point)) {
        return self.textView;
    }
    
    return hitView;
}
@end
