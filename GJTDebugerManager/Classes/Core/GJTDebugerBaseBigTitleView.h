//
//  GJTDebugerBaseBigTitleView.h
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GJTDebugerBaseBigTitleViewDelegate <NSObject>

- (void)bigTitleCloseClick;

@end



@interface GJTDebugerBaseBigTitleView : UIView


@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id<GJTDebugerBaseBigTitleViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
