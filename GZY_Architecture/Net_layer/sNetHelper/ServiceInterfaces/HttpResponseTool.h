//
//  HttpResponseTool.h
//  ELottery
//
//  Created by sealedace on 13-11-28.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDefinition.h"

@interface HttpResponseTool : NSObject

typedef NS_ENUM(NSInteger, ResponseType){
    ResponseType_Html,
    ResponseType_Json,
    ResponseType_Data
};

+ (id)parseResponse:(NSDictionary*)response withType:(WebServiceType)type;
/**
 *  获取各个接口的返回类型是神马
 *
 *  @param type 接口类型
 *
 *  @return 返回数据的格式
 */
+ (ResponseType)getResponseType:(WebServiceType)type;

@end
