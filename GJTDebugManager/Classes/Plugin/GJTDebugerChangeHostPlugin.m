//
//  GJTDebugerChangeHostPlugin.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/26.
//

#import "GJTDebugerChangeHostPlugin.h"


#import <GJTAdditionKit/GJTAdditionKit.h>
#import "GJTDebugerManager.h"
#import "GJTDebugerHomeWindow.h"
#import "GJTChangeHostViewController.h"

@implementation GJTDebugerChangeHostPlugin

- (void)pluginDidLoad {

    GJTChangeHostViewController *changeHostVC = [[GJTChangeHostViewController alloc] init];
    [[GJTDebugerHomeWindow shareInstance] openPlugin:changeHostVC];
    
}

@end
