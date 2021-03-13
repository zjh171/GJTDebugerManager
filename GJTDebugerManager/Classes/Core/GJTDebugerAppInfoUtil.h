//
//  GJTDebugerAppInfoUtil.h
//  GJTDebuger
//
//  Created by kyson on 2021/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJTDebugerAppInfoUtil : NSObject


/**
 DeviceInfo：获取当前设备的 用户自定义的别名，例如：库克的 iPhone 9
 
 @return 当前设备的 用户自定义的别名，例如：库克的 iPhone 9
 */
+ (NSString *)iphoneName;

/**
 DeviceInfo：获取当前设备的 系统名称，例如：iOS 13.1
 
 @return 当前设备的 系统名称，例如：iOS 13.1
 */
+ (NSString *)iphoneSystemVersion;

+ (NSString *)bundleIdentifier;

+ (NSString *)bundleVersion;

+ (NSString *)bundleShortVersionString;

+ (BOOL)isIPhoneXSeries;

+ (BOOL)isIpad;

/// 设备是否模拟器
+ (BOOL)isSimulator;

@end

NS_ASSUME_NONNULL_END
