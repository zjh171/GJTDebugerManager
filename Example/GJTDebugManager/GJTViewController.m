//
//  GJTViewController.m
//  GJTDebugManager
//
//  Created by zjh171 on 03/13/2021.
//  Copyright (c) 2021 zjh171. All rights reserved.
//

#import "GJTViewController.h"
#import <GJTDebugManager/GJTDebugerManager.h>

@interface GJTViewController ()

@end

@implementation GJTViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [[GJTDebugerManager shareInstance] install];
//    [[GJTDebugerManager shareInstance] showHomeWindow];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
