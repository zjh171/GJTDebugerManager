//
//  GJTDebugerDefine.h
//  Pods
//
//  Created by kyson on 2021/3/22.
//


#ifndef Header_h
#define Header_h


#define GJTDebugerScreenWidth [UIScreen mainScreen].bounds.size.width
#define GJTDebugerScreenHeight [UIScreen mainScreen].bounds.size.height

//根据750*1334分辨率计算size
#define kDoraemonSizeFrom750(x) ((x)*GJTDebugerScreenWidth/750)
// 如果横屏显示
#define kDebugerSizeFrom750_Landscape(x) (kInterfaceOrientationPortrait ? kDoraemonSizeFrom750(x) : ((x)*GJTDebugerScreenHeight/750))

#define kInterfaceOrientationPortrait UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)


#define DoraemonShowPluginNotification @"DoraemonShowPluginNotification"
#define DoraemonClosePluginNotification @"DoraemonClosePluginNotification"
#define DoraemonQuickOpenLogVCNotification @"DoraemonQuickOpenLogVCNotification"

#define GJTDebugerUserDefaultsDomainName @"GJTDebugerDomainName"
#define GJTDebugerUserDefaultsPluginName_Login @"QuickLogin"
#define GJTDebugerServerTypeName @"bigHelper_serverType"
#define GJTNetworkConfigurationTypeName @"bigHelper_networkConfigType"
#define GJTDebugerSimulationCityName @"bigHelper_simulationCityName"
#define GJTDebugerUserDefaultSparrowSwitch @"UserDefault_Debuger_Sparrow_Switch"
#define GJTDebugerUserDefaultSimulateLocation @"UserDefault_Debuger_Simulate_Location"


typedef NS_ENUM(NSUInteger, GJTDebugerServerType) {
    GJTDebugerServerTypeProduce       = 0,
    GJTDebugerServerTypePreProduce    = 1,
    GJTDebugerServerTypeDaily         = 2,
};


typedef NS_ENUM(NSUInteger, GJTDebugerManagerPluginType) {
    #pragma mark - weex专项工具
    // 日志
    GJTDebugerManagerPluginType_DoraemonWeexLogPlugin,
    // 缓存
    GJTDebugerManagerPluginType_DoraemonWeexStoragePlugin,
    // 信息
    GJTDebugerManagerPluginType_DoraemonWeexInfoPlugin,
    // DevTool
    GJTDebugerManagerPluginType_DoraemonWeexDevToolPlugin,
    #pragma mark - 常用工具
    // App信息
    GJTDebugerManagerPluginType_DoraemonAppInfoPlugin,
    // 沙盒浏览
    GJTDebugerManagerPluginType_DoraemonSandboxPlugin,
    // MockGPS
    GJTDebugerManagerPluginType_DoraemonGPSPlugin,
    // H5任意门
    GJTDebugerManagerPluginType_DoraemonH5Plugin,
    // Crash查看
    GJTDebugerManagerPluginType_DoraemonCrashPlugin,
    // 子线程UI
    GJTDebugerManagerPluginType_DoraemonSubThreadUICheckPlugin,
    // 清除本地数据
    GJTDebugerManagerPluginType_DoraemonDeleteLocalDataPlugin,
    // NSLog
    GJTDebugerManagerPluginType_DoraemonNSLogPlugin,
    // 日志显示
    GJTDebugerManagerPluginType_DoraemonCocoaLumberjackPlugin,
    // 数据库工具
    GJTDebugerManagerPluginType_DoraemonDatabasePlugin,
    
    #pragma mark - 性能检测
    // 帧率监控
    GJTDebugerManagerPluginType_DoraemonFPSPlugin,
    // CPU监控
    GJTDebugerManagerPluginType_DoraemonCPUPlugin,
    // 内存监控
    GJTDebugerManagerPluginType_DoraemonMemoryPlugin,
    // 流量监控
    GJTDebugerManagerPluginType_DoraemonNetFlowPlugin,
    // 卡顿检测
    GJTDebugerManagerPluginType_DoraemonANRPlugin,
    // 自定义 性能数据保存到本地
    GJTDebugerManagerPluginType_DoraemonAllTestPlugin,
    // Load耗时
    GJTDebugerManagerPluginType_DoraemonMethodUseTimePlugin,
    // 大图检测
    GJTDebugerManagerPluginType_DoraemonLargeImageFilter,
    
    #pragma mark - 视觉工具
    // 颜色吸管
    GJTDebugerManagerPluginType_DoraemonColorPickPlugin,
    // 组件检查
    GJTDebugerManagerPluginType_DoraemonViewCheckPlugin,
    // 对齐标尺
    GJTDebugerManagerPluginType_DoraemonViewAlignPlugin,
    // 元素边框线
    GJTDebugerManagerPluginType_DoraemonViewMetricsPlugin
};


#endif /* Header_h */
