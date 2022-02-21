//
//  UIImage+GJTDebuger.m
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import "UIImage+GJTDebuger.h"

NSString *const kGJTDebugerManagerBundleName = @"GJTDebugerManager";


@implementation UIImage(GJTDebuger)


+ (UIImage *)debuger_imageNamed:(NSString *)name{
    if(name){
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"DoraemonManager")];
        NSURL *url = [bundle URLForResource:@"DoraemonKit" withExtension:@"bundle"];
        //release 环境下，没有 DoraemonManager
        if (bundle == nil || url == nil) {
            bundle = [NSBundle bundleForClass:NSClassFromString(kGJTDebugerManagerBundleName)];
            url = [bundle URLForResource:kGJTDebugerManagerBundleName withExtension:@"bundle"];
        }
        
        NSString *imageName = nil;
        UIImage *image = nil;
        if (url != nil ) {
            NSBundle *imageBundle = [NSBundle bundleWithURL:url];
            //如果非 xcassets 方式
            CGFloat scale = [UIScreen mainScreen].scale;
            if (ABS(scale-3) <= 0.001){
                imageName = [NSString stringWithFormat:@"%@@3x",name];
            }else if(ABS(scale-2) <= 0.001){
                imageName = [NSString stringWithFormat:@"%@@2x",name];
            }else{
                imageName = name;
            }
            image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:imageName ofType:@"png"]];
            if (!image) {
                image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:name ofType:@"png"]];
                if (!image) {
                    image = [UIImage imageNamed:name];
                }
            }
            
            //如果 xcassets 方式
            if (!image) {
                bundle = [NSBundle bundleForClass:NSClassFromString(kGJTDebugerManagerBundleName)];
                url = [bundle URLForResource:kGJTDebugerManagerBundleName withExtension:@"bundle"];
                NSBundle *imageBundle = [NSBundle bundleWithURL:url];
                image = [UIImage imageNamed:name inBundle:imageBundle compatibleWithTraitCollection:nil];
            }
            
            if (!image) {
                image = [UIImage imageNamed:name];
            }
            
        } else {
            image = [UIImage imageNamed:name];
            if (image == nil) {
                image = [UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:@"png"]];
                if (!image) {
                    image = [UIImage imageNamed:@"AppIcon"];
                }

            }
        }
        
        return image;
    }
    
    return nil;
}


@end
