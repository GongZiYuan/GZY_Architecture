//
//  ServiceDataAnalyze.h
//  ECalendar-Pro
//
//  Created by B.E.N on 15/6/9.
//  Copyright (c) 2015年 etouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ServiceDataAnalyzer)
+ (NSDictionary*)addCustom1JsonAnalyze:(NSDictionary*)dic;
@end


@class ServiceDataJsonAnalyze;

extern NSString* const kServiceDataAnalyzeClassName;

extern NSString * const ServiceDataCustomJsonAnalyzeClassName_1;


typedef enum : NSUInteger {
    ServiceDataTypeJson = 1,
    ServiceDataTypeNotJson = 2,
} ServiceDataType;


typedef void(^ServiceDataAnalyzeManagerParaserFinishedBlock)(id data);

@interface ServiceDataAnalyzeManager : NSObject
+ (void)analyzeWithData:(NSData*)responseData userInfo:(NSDictionary*)userInfo paraserFinishedBlock:(ServiceDataAnalyzeManagerParaserFinishedBlock)paraserFinishedBlock;

@end


@interface ServiceDataBaseAnalyze : NSObject
/**
 *  定义基类方法，子类需要重写该方法
 *
 *  @param responseData 需要解析的数据
 *
 *  @return 解析之后返回的数据
 */
- (NSDictionary*)serviceDataAnalyze:(id)responseData;
@end


@interface ServiceDataJsonAnalyze : ServiceDataBaseAnalyze

@end


@interface ServiceDataCustom1JsonAnalyze : ServiceDataJsonAnalyze

@end

