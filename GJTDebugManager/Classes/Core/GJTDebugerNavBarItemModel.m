//
//  GJTDebugerNavBarItemModel.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import "GJTDebugerNavBarItemModel.h"

@implementation GJTDebugerNavBarItemModel



- (instancetype)initWithText:(NSString *)text color:(UIColor *)color selector:(SEL)selector{
    self = [[GJTDebugerNavBarItemModel alloc] init];
    self.type = GJTDebugerNavBarItemTypeText;
    self.text = text;
    self.textColor = color;
    self.selector = selector;
    return self;
}
- (instancetype)initWithImage:(UIImage *)image selector:(SEL)selector{
    self = [[GJTDebugerNavBarItemModel alloc] init];
    self.type = GJTDebugerNavBarItemTypeImage;
    self.image = image;
    self.selector = selector;
    return self;
}



@end
