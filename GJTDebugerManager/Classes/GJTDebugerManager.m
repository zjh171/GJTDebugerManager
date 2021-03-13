//
//  GJTDebugerManager.m
//  AFNetworking
//
//  Created by kyson on 2021/3/26.
//

#import <GJTAdditionKit/GJTAdditionKit.h>


#import "GJTDebugerEntryView.h"
#import "GJTDebugerHomeWindow.h"
#import "GJTDebugerManager.h"
#import "GJTDebugerStartPluginProtocol.h"

#define kTitle @"title"
#define kDesc @"desc"
#define kIcon @"icon"
#define kPluginName @"pluginName"
#define kAtModule @"atModule"
#import "GJTDebugerDefine.h"

@implementation GJTDebugerManagerPluginTypeModel

@end

@interface GJTDebugerManager ()

@property (nonatomic, strong) GJTDebugerEntryView *entryView;

@property (nonatomic, strong) NSMutableArray *startPlugins;

@property (nonatomic, assign) BOOL hasInstall;

@end

@implementation GJTDebugerManager

static GJTDebugerManager *instance = nil;

+ (nonnull GJTDebugerManager *)shareInstance {
    static dispatch_once_t once;
    static GJTDebugerManager *instance;
    dispatch_once(&once, ^{
        instance = [[GJTDebugerManager alloc] init];
    });
    return instance;
}

- (void)install {
    [self installWithCustomBlock:^{

    }];
}

- (void)installWithCustomBlock:(void (^)(void))customBlock {
    //保证install只执行一次
    if (_hasInstall) {
        [self showHomeWindow];
        return;
    }
    _hasInstall = YES;
    for (int i = 0; i < _startPlugins.count; i++) {
        NSString *pluginName = _startPlugins[i];
        Class pluginClass = NSClassFromString(pluginName);
        id<GJTDebugerStartPluginProtocol> plugin = [[pluginClass alloc] init];
        if (plugin) {
            [plugin startPluginDidLoad];
        }
    }

    [self initData];
    customBlock();

//    if ([GJTMacroConfig isDebug]) {
//        [self initEntry];
//    }
    [self initEntry];
}

- (void)initData {
    [[GJTDebugerManager shareInstance] addPluginWithTitle:@"切换服务器"
                                                       icon:@"exchange_host"
                                                       desc:@""
                                                 pluginName:@"GJTDebugerChangeHostPlugin"
                                                   atModule:@"业务相关"];

    //常用工具
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonAppInfoPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonDeleteLocalDataPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonSandboxPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonH5Plugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonSubThreadUICheckPlugin];
//    //性能监控
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonFPSPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonCPUPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonMemoryPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonANRPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonLargeImageFilter];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonAllTestPlugin];
//    //视觉工具
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonColorPickPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonViewCheckPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonViewAlignPlugin];
//    [self addPluginWithPluginType:GJTDebugerManagerPluginType_DoraemonViewMetricsPlugin];
    
    [[GJTDebugerManager shareInstance] addPluginWithTitle:@"关于"
                                                       icon:@"about"
                                                       desc:@""
                                                 pluginName:@"GJTDebugerAboutPlugin"
                                                   atModule:@"设置"];
}

/**
 初始化工具入口
 */
- (void)initEntry {
    _entryView = [[GJTDebugerEntryView alloc] init];
    [_entryView makeKeyAndVisible];
}

- (void)addStartPlugin:(NSString *)pluginName {
    if (!_startPlugins) {
        _startPlugins = [[NSMutableArray alloc] init];
    }
    [_startPlugins addObject:pluginName];
}

- (void)addPluginWithTitle:(NSString *)title
                      icon:(NSString *)iconName
                      desc:(NSString *)desc
                pluginName:(NSString *)entryName
                  atModule:(NSString *)moduleName {
    NSMutableDictionary *pluginDic = [self foundGroupWithModule:moduleName];
    pluginDic[@"name"] = title;
    pluginDic[@"icon"] = iconName;
    pluginDic[@"desc"] = desc;
    pluginDic[@"pluginName"] = entryName;
}

- (void)addPluginWithTitle:(NSString *)title
                      icon:(NSString *)iconName
                      desc:(NSString *)desc
                pluginName:(NSString *)entryName
                  atModule:(NSString *)moduleName
                    handle:(void (^)(NSDictionary *))handleBlock {
    NSMutableDictionary *pluginDic = [self foundGroupWithModule:moduleName];
    pluginDic[@"name"] = title;
    pluginDic[@"icon"] = iconName;
    pluginDic[@"desc"] = desc;
    pluginDic[@"pluginName"] = entryName;
    pluginDic[@"handleBlock"] = [handleBlock copy];
}
- (NSMutableDictionary *)foundGroupWithModule:(NSString *)module {
    NSMutableDictionary *pluginDic = [NSMutableDictionary dictionary];
    pluginDic[@"moduleName"] = module;
    __block BOOL hasModule = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *moduleDic = obj;
        NSString *moduleName = moduleDic[@"moduleName"];
        if ([moduleName isEqualToString:module]) {
            hasModule = YES;
            NSMutableArray *pluginArray = moduleDic[@"pluginArray"];
            if (pluginArray) {
                [pluginArray addObject:pluginDic];
            }
            [moduleDic setValue:pluginArray forKey:@"pluginArray"];
            *stop = YES;
        }
    }];
    if (!hasModule) {
        NSMutableArray *pluginArray = [[NSMutableArray alloc] initWithObjects:pluginDic, nil];
        [self registerPluginArray:pluginArray withModule:module];
    }
    return pluginDic;
}
- (void)removePluginWithPluginType:(GJTDebugerManagerPluginType)pluginType {
    GJTDebugerManagerPluginTypeModel *model = [self getDefaultPluginDataWithPluginType:pluginType];
    [self removePluginWithPluginName:model.pluginName atModule:model.atModule];
}

- (void)removePluginWithPluginName:(NSString *)pluginName atModule:(NSString *)moduleName {
    [self unregisterPlugin:pluginName withModule:moduleName];
}

- (void)addPluginWithPluginType:(GJTDebugerManagerPluginType)pluginType {
    GJTDebugerManagerPluginTypeModel *model = [self getDefaultPluginDataWithPluginType:pluginType];
    [self addPluginWithTitle:model.title
                        icon:model.icon
                        desc:model.desc
                  pluginName:model.pluginName
                    atModule:model.atModule];
}

#pragma mark - default data
- (GJTDebugerManagerPluginTypeModel *)getDefaultPluginDataWithPluginType:(GJTDebugerManagerPluginType)pluginType {
    NSArray *dataArray = @{
        @(GJTDebugerManagerPluginType_DoraemonWeexLogPlugin): @[
            @{kTitle: @"日志"},
            @{kDesc: @"Weex日志显示"},
            @{kIcon: @"doraemon_log"},
            @{kPluginName: @"DoraemonWeexLogPlugin"},
            @{kAtModule: @"Weex专区"}
        ],
        @(GJTDebugerManagerPluginType_DoraemonWeexStoragePlugin): @[
            @{kTitle: @"缓存"},
            @{kDesc: @"weex storage 查看"},
            @{kIcon: @"doraemon_file"},
            @{kPluginName: @"DoraemonWeexStoragePlugin"},
            @{kAtModule: @"Weex专区"}
        ],
        @(GJTDebugerManagerPluginType_DoraemonWeexInfoPlugin): @[
            @{kTitle: @"信息"},
            @{kDesc: @"weex 信息查看"},
            @{kIcon: @"doraemon_app_info"},
            @{kPluginName: @"DoraemonWeexInfoPlugin"},
            @{kAtModule: @"Weex专区"}
        ],
        @(GJTDebugerManagerPluginType_DoraemonWeexDevToolPlugin): @[
            @{kTitle: @"DevTool"},
            @{kDesc: @"weex devtool"},
            @{kIcon: @"doraemon_default"},
            @{kPluginName: @"DoraemonWeexDevTooloPlugin"},
            @{kAtModule: @"Weex专区"}
        ],
        @(GJTDebugerManagerPluginType_DoraemonAppInfoPlugin): @[
            @{kTitle: @"App信息"},
            @{kDesc: (@"App的一些基本信息")},
            @{kIcon: @"doraemon_app_info"},
            @{kPluginName: @"DoraemonAppInfoPlugin"},
            @{kAtModule: (@"常用工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonSandboxPlugin): @[
            @{kTitle: (@"沙盒浏览")},
            @{kDesc: (@"沙盒浏览")},
            @{kIcon: @"doraemon_file"},
            @{kPluginName: @"DoraemonSandboxPlugin"},
            @{kAtModule: (@"常用工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonGPSPlugin): @[
            @{kTitle: @"MockGPS"},
            @{kDesc: @"MockGPS"},
            @{kIcon: @"doraemon_mock_gps"},
            @{kPluginName: @"DoraemonGPSPlugin"},
            @{kAtModule: (@"常用工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonH5Plugin): @[
            @{kTitle: (@"H5跳转")},
            @{kDesc: (@"H5通用跳转")},
            @{kIcon: @"doraemon_h5"},
            @{kPluginName: @"DoraemonH5Plugin"},
            @{kAtModule: (@"常用工具")}
        ],

        @(GJTDebugerManagerPluginType_DoraemonSubThreadUICheckPlugin): @[
            @{kTitle: (@"子线程UI")},
            @{kDesc: (@"非主线程UI渲染检查")},
            @{kIcon: @"doraemon_ui"},
            @{kPluginName: @"DoraemonSubThreadUICheckPlugin"},
            @{kAtModule: (@"常用工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonDeleteLocalDataPlugin): @[
            @{kTitle: (@"清除数据")},
            @{kDesc: (@"清除数据")},
            @{kIcon: @"doraemon_qingchu"},
            @{kPluginName: @"DoraemonDeleteLocalDataPlugin"},
            @{kAtModule: (@"常用工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonNSLogPlugin): @[
            @{kTitle: @"NSLog"},
            @{kDesc: @"NSLog"},
            @{kIcon: @"doraemon_nslog"},
            @{kPluginName: @"DoraemonNSLogPlugin"},
            @{kAtModule: (@"常用工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonCocoaLumberjackPlugin): @[
            @{kTitle: @"Lumberjack"},
            @{kDesc: (@"日志显示")},
            @{kIcon: @"doraemon_log"},
            @{kPluginName: @"DoraemonCocoaLumberjackPlugin"},
            @{kAtModule: (@"常用工具")}
        ],

        @(GJTDebugerManagerPluginType_DoraemonDatabasePlugin): @[
            @{kTitle: @"YYDatabase"},
            @{kDesc: (@"数据库")},
            @{kIcon: @"doraemon_database"},
            @{kPluginName: @"DoraemonDatabasePlugin"},
            @{kAtModule: (@"常用工具")}
        ],

        // 性能检测
        @(GJTDebugerManagerPluginType_DoraemonCrashPlugin): @[
            @{kTitle: (@"Crash查看")},
            @{kDesc: (@"Crash本地查看")},
            @{kIcon: @"doraemon_crash"},
            @{kPluginName: @"DoraemonCrashPlugin"},
            @{kAtModule: (@"业务相关")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonNetFlowPlugin): @[
            @{kTitle: (@"网络抓包")},
            @{kDesc: (@"流量监控")},
            @{kIcon: @"doraemon_net"},
            @{kPluginName: @"GJTNetFlowFlugin"},
            @{kAtModule: (@"业务相关")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonFPSPlugin): @[
            @{kTitle: (@"帧率")},
            @{kDesc: (@"帧率监控")},
            @{kIcon: @"doraemon_fps"},
            @{kPluginName: @"DoraemonFPSPlugin"},
            @{kAtModule: (@"性能检测")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonCPUPlugin): @[
            @{kTitle: @"CPU"},
            @{kDesc: (@"CPU监控")},
            @{kIcon: @"doraemon_cpu"},
            @{kPluginName: @"DoraemonCPUPlugin"},
            @{kAtModule: (@"性能检测")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonMemoryPlugin): @[
            @{kTitle: (@"内存")},
            @{kDesc: (@"内存监控")},
            @{kIcon: @"doraemon_memory"},
            @{kPluginName: @"DoraemonMemoryPlugin"},
            @{kAtModule: (@"性能检测")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonANRPlugin): @[
            @{kTitle: (@"卡顿")},
            @{kDesc: (@"卡顿监控")},
            @{kIcon: @"doraemon_kadun"},
            @{kPluginName: @"DoraemonANRPlugin"},
            @{kAtModule: (@"性能检测")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonAllTestPlugin): @[
            @{kTitle: (@"自定义")},
            @{kDesc: (@"性能数据保存到本地")},
            @{kIcon: @"doraemon_default"},
            @{kPluginName: @"DoraemonAllTestPlugin"},
            @{kAtModule: (@"性能检测")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonMethodUseTimePlugin): @[
            @{kTitle: (@"Load耗时")},
            @{kDesc: (@"Load方法消耗时间")},
            @{kIcon: @"doraemon_method_use_time"},
            @{kPluginName: @"DoraemonMethodUseTimePlugin"},
            @{kAtModule: (@"性能检测")}
        ],

        @(GJTDebugerManagerPluginType_DoraemonLargeImageFilter): @[
            @{kTitle: (@"大图检测")},
            @{kDesc: (@"大图检测")},
            @{kIcon: @"doraemon_net"},
            @{kPluginName: @"DoraemonLargeImagePlugin"},
            @{kAtModule: (@"性能检测")}
        ],
        // 视觉工具
        @(GJTDebugerManagerPluginType_DoraemonColorPickPlugin): @[
            @{kTitle: (@"颜色吸管")},
            @{kDesc: (@"颜色拾取器")},
            @{kIcon: @"doraemon_straw"},
            @{kPluginName: @"DoraemonColorPickPlugin"},
            @{kAtModule: (@"视觉工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonViewCheckPlugin): @[
            @{kTitle: (@"组件检查")},
            @{kDesc: (@"View查看器")},
            @{kIcon: @"doraemon_view_check"},
            @{kPluginName: @"DoraemonViewCheckPlugin"},
            @{kAtModule: (@"视觉工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonViewAlignPlugin): @[
            @{kTitle: (@"对齐标尺")},
            @{kDesc: (@"查看组件是否对齐")},
            @{kIcon: @"doraemon_align"},
            @{kPluginName: @"DoraemonViewAlignPlugin"},
            @{kAtModule: (@"视觉工具")}
        ],
        @(GJTDebugerManagerPluginType_DoraemonViewMetricsPlugin): @[
            @{kTitle: (@"元素边框线")},
            @{kDesc: (@"显示元素边框线")},
            @{kIcon: @"doraemon_viewmetrics"},
            @{kPluginName: @"DoraemonViewMetricsPlugin"},
            @{kAtModule: (@"视觉工具")}
        ]
    }[@(pluginType)];

    GJTDebugerManagerPluginTypeModel *model = [GJTDebugerManagerPluginTypeModel new];
    model.title = dataArray[0][kTitle];
    model.desc = dataArray[1][kDesc];
    model.icon = dataArray[2][kIcon];
    model.pluginName = dataArray[3][kPluginName];
    model.atModule = dataArray[4][kAtModule];

    return model;
}

- (void)registerPluginArray:(NSMutableArray *)array withModule:(NSString *)moduleName {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:moduleName forKey:@"moduleName"];
    [dic setValue:array forKey:@"pluginArray"];
    [_dataArray addObject:dic];
}

- (void)unregisterPlugin:(NSString *)pluginName withModule:(NSString *)moduleName {
    if (!_dataArray) {
        return;
    }
    id object;
    for (object in _dataArray) {
        NSString *tempModuleName = [((NSMutableDictionary *)object) valueForKey:@"moduleName"];
        if ([tempModuleName isEqualToString:moduleName]) {
            NSMutableArray *tempPluginArray = [((NSMutableDictionary *)object) valueForKey:@"pluginArray"];
            id pluginObject;
            for (pluginObject in tempPluginArray) {
                NSString *tempPluginName = [((NSMutableDictionary *)pluginObject) valueForKey:@"pluginName"];
                if ([tempPluginName isEqualToString:pluginName]) {
                    [tempPluginArray removeObject:pluginObject];
                    return;
                }
            }
        }
    }
}

- (BOOL)isShowDoraemon {
    return !_entryView.hidden;
}

- (void)showDoraemon {
    if (_entryView.hidden) {
        _entryView.hidden = NO;
    }
}

- (void)hiddenDoraemon {
    if (!_entryView.hidden) {
        _entryView.hidden = YES;
    }
}

- (void)hiddenHomeWindow {
    [[GJTDebugerHomeWindow shareInstance] hide];
}

- (void)showHomeWindow {
    [[GJTDebugerHomeWindow shareInstance] show];
}

@end
