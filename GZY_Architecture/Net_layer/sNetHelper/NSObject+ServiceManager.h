//
//  NSObject+ServiceManager.h
//  ELottery
//
//  Created by sealedace on 13-11-28.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDefinition.h"
#import "HttpRequestTool.h"

@class HttpRequestService;

/**
 *  NSObject为ServiceManager的扩展
 */
@interface NSObject (ServiceManager)
<SerivceManagerDelegate>

/**
 *  快速调用ServiceManager请求
 *
 *  @param type            请求的类型
 *  @param param           请求的字典
 *  @param method          请求的方法
 *  @param userInfo        请求的用户信息
 *
 *  @return serviceID，用于区分不用的接口实例
 */
- (WebServiceID *)makeRequestForType:(WebServiceType)type params:(NSDictionary *)param method:(NSString*)method userInfo:(NSDictionary*)userInfo;

/**
 *  快速调用ServiceManager请求
 *  该方法用于请求参数中需要appSign的请求.
 */

- (WebServiceID *)makeRequestNeedAppSignForType:(WebServiceType)type params:(NSDictionary *)param method:(NSString*)method userInfo:(NSDictionary*)userInfo;

/**
 *  获取service的类型
 *
 *  @param sid ELServiceID
 *
 *  @return ELServiceType
 */
- (WebServiceType)getServiceTypeByID:(WebServiceID *)sid;
/**
 *  获取当前某一类型正在运行的请求。
 *  @param type 要获取的接口类型。如果要获取所有的类型，请传递 ServiceType_Invalid
 *
 *  @return WebServiceID的数组
 */
- (NSArray *)runningServices:(WebServiceType)type;

/**
 *  清空当前的所有网络请求
 *
 */
- (void)clearAllServices;

/**
 *  指定网络类型取消请求
 *
 *  @param type 网络类型
 */
- (void)clearAllServicesWithType:(WebServiceType)type;

@end



