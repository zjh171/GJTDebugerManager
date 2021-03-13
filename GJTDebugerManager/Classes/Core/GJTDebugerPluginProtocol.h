//
//  GJTDebugerPluginProtocol.h
//  Pods
//
//  Created by kyson on 2021/3/22.
//

#ifndef GJTDebugerPluginProtocol_h
#define GJTDebugerPluginProtocol_h

#import <Foundation/Foundation.h>


@protocol GJTDebugerPluginProtocol <NSObject>

@optional
- (void)pluginDidLoad;
- (void)pluginDidLoad:(NSDictionary *)itemData;

@end


#endif /* GJTDebugerPluginProtocol_h */
