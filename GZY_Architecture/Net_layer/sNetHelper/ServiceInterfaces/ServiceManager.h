//
//  ServiceManager.h
//  ELottery
//
//  Created by sealedace on 13-11-27.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDefinition.h"

/**
 *  接口管理类
 */
@interface ServiceManager : NSObject<SerivceCallbackDelegate>{
    NSMutableDictionary *_servicesDictionary;
}

+ (ServiceManager *)sharedInstance;

/**
 *  发出一个请求
 *
 *  @param serviceType 请求类型
 *  @param param       请求参数
 *  @param method      请求方法
 *  @param userInfo    用户信息
 *
 *  @return 返回该请求的标示
 */
- (WebServiceID *)request:(WebServiceType)serviceType param:(NSDictionary*)param method:(NSString*)method userInfo:(NSDictionary*)userInfo;


/**
 *  取消请求
 *
 *  @param serviceID 接口的ID
 */
- (void)cancelRequestWithID:(NSString *)serviceID;

@end

