//
//  GJTDebugerNavBarItemModel.h
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GJTDebugerNavBarItemType) {
    GJTDebugerNavBarItemTypeText = 0,
    GJTDebugerNavBarItemTypeImage,
};

@interface GJTDebugerNavBarItemModel : NSObject


@property (nonatomic, assign) GJTDebugerNavBarItemType type;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) SEL selector;

- (instancetype)initWithText:(NSString *)text color:(UIColor *)color selector:(SEL)selector;
- (instancetype)initWithImage:(UIImage *)image selector:(SEL)selector;


@end

NS_ASSUME_NONNULL_END
