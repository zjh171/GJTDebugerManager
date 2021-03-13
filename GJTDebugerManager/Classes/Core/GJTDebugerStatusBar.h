//
//  GJTDebugerStatusBar.h
//  AFNetworking
//
//  Created by kyson on 2021/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GJTDebugerStatesBarFrom) {
    GJTDebugerStatesBarFromNSLog = 0,
    GJTDebugerStatesBarFromCocoaLumberjack
};


@interface GJTDebugerStatusBar : UIWindow


+ (GJTDebugerStatusBar *)shareInstance;

- (void)show;

- (void)renderUIWithContent:(NSString *)content from:(GJTDebugerStatesBarFrom)from;

- (void)hide;


@end

NS_ASSUME_NONNULL_END
