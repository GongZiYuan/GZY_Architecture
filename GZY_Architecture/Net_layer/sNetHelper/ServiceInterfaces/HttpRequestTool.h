//
//  HttpRequestTool.h
//  ELottery
//
//  Created by sealedace on 13-11-27.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDefinition.h"
#import "ServiceDataAnalyze.h"



@interface HttpRequestTool : NSObject
/**
 *  获取api地址
 *
 *  @param type   请求类型
 *  @param params url附加参数
 *
 *  @return api地址
 */
+ (NSString*)getApiAddressWithParams:(WebServiceType)type params:(NSDictionary*)params;

/**
 *  GET请求的参数拼接
 *
 *  @param params 参数字典
 *  @param url    首URL
 *
 *  @return 拼接完成的请求url
 */
+ (NSString *)addParameters:(NSDictionary *)params toUrlString:(NSString *)url;


+ (NSString*)getRequestUUID:(WebServiceType)serviceType param:(NSDictionary*)param userInfo:(NSDictionary*)userInfo;

/**
 *  加密appSign
 *
 *  @param params 除了appSign的值
 *
 *  @return 添加appSign的值
 */
+(NSDictionary*)encryptAppSign:(NSDictionary*)params;

@end
