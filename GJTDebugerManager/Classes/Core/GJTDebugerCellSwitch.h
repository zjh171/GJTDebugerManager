//
//  GJTDebugerCellSwitch.h
//  GJTDebuger
//
//  Created by kyson on 2021/3/19.
//  Copyright © 2020 me.ele. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol DebugerSwitchViewDelegate<NSObject>

- (void)changeSwitchOn:(BOOL)on sender:(id)sender;

@end



@interface GJTDebugerCellSwitch : UIView

@property (nonatomic, weak) id<DebugerSwitchViewDelegate> delegate;

@property (nonatomic, strong) UISwitch *switchView;

- (void)renderUIWithTitle:(NSString *)title switchOn:(BOOL)on;

- (void)needTopLine;

- (void)needDownLine;

@end

NS_ASSUME_NONNULL_END
