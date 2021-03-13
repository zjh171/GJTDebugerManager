//
//  GJTScanPlugin.m
//  AGEmojiKeyboard
//
//  Created by kyson on 2021/3/23.
//

#import "GJTScanPlugin.h"


#import <GJTAdditionKit/GJTAdditionKit.h>
#import "GJTDebugerManager.h"
#import "GJTDebugerHomeWindow.h"
#import "GJTDebugScanningViewController.h"

@implementation GJTScanPlugin


- (void)pluginDidLoad {
    GJTDebugScanningViewController *changeHostVC = [[GJTDebugScanningViewController alloc] init];
    [[GJTDebugerHomeWindow shareInstance] openPlugin:changeHostVC];
}



@end
