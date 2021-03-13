//
//  GJTDebugerManager.h
//  AFNetworking
//
//  Created by kyson on 2021/3/26.
//

#import <Foundation/Foundation.h>
#import "GJTDebugerDefine.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^GJTDebugerChangeHostBlock)(GJTDebugerServerType serverType,BOOL needLoginOut);

typedef void (^GJTDebugerSaveSimulateLocationBlock)(NSDictionary *location);

typedef void (^GJTDebugerMockNetworkRequestBlock)(BOOL mock);

typedef void (^GJTDebugerH5EntranceBlock)(NSString *url);

typedef void (^GJTDebugerInvokeDoraemonBlock)(void);


@interface GJTDebugerManagerPluginTypeModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *pluginName;
@property(nonatomic, copy) NSString *atModule;

@end

@interface GJTDebugerManager : NSObject

@property (nonatomic,strong) NSMutableArray *dataArray;

+ (nonnull GJTDebugerManager *)shareInstance ;


/// 安装
-(void) install ;

//安装完成后执行指定操作
- (void)installWithCustomBlock:(void (^)(void))customBlock ;

//添加某个 plugin
- (void)addPluginWithTitle:(NSString *)title icon:(NSString *)iconName desc:(NSString *)desc pluginName:(NSString *)entryName atModule:(NSString *)moduleName;

///展示d
- (BOOL)isShowDoraemon ;
///隐藏主页面
- (void)hiddenHomeWindow;
/// 隐藏
- (void)hiddenDoraemon;

- (void)showDoraemon ;

- (void)showHomeWindow ;

@property (nonatomic, copy) GJTDebugerChangeHostBlock changHostBlock;

@property (nonatomic, copy) GJTDebugerMockNetworkRequestBlock mockNetworkRequestBlock;

@property (nonatomic, copy) GJTDebugerH5EntranceBlock H5EntranceBlock;

///需要插入 doraemon 的代码的 block
@property (nonatomic, copy) GJTDebugerInvokeDoraemonBlock invokeDoraemonBlock;

@end

NS_ASSUME_NONNULL_END
