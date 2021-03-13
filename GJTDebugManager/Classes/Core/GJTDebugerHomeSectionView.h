//
//  GJTDebugerHomeSectionView.h
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJTDebugerHomeSectionView : UIView



- (void)renderUIWithData:(NSDictionary *)data;
- (void)updateUILayoutWithData:(NSDictionary *)data;

+ (CGFloat)viewHeightWithData:(NSDictionary *)data;


@end

NS_ASSUME_NONNULL_END
