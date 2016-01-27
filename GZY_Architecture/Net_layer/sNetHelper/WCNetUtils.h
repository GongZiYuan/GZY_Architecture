//
//  WCNetUtils.h
//  ECalendar-Pro
//
//  Created by nyz_star on 15/11/19.
//  Copyright © 2015年 etouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ServiceManager.h"

typedef enum :NSInteger{
    NetRequestMethodType_GET,
    NetRequestMethodType_POST
}NetRequestMethodType;

/**
 *  网络请求回调
 *
 *  @param err      是否有错误  nil 无错误，不为nil则有错误，需要处理err
 *  @param data     返回的数据
 *  @param userInfo 额外的参数标志
 */
typedef void(^WCServiceCallBack)(NSError *err,id data,NSDictionary *userInfo);

/**
 *  请求载体类 用于配置
 */

@interface WCServiceMaker : NSObject

@property(nonatomic,assign) WebServiceType sType;     //请求类型
@property(nonatomic,strong) NSDictionary *param;        //请求参数
@property(nonatomic,strong) NSDictionary *userInfo;     //额外信息dic
@property(nonatomic,assign) NetRequestMethodType method;  //请求方式
@property(nonatomic,assign) BOOL isNeedAppSign;           //是否需要appSign

@end

typedef void(^WCServiceBuilder)(WCServiceMaker *maker);

@interface WCNetUtils : NSObject

/**
 *  网络请求类
 *
 *  @param builder  创建请求的参数
 *  @param callBack 请求的回调
 *
 *  @return 请求的唯一标识符 service id
 */
- (WebServiceID *)wcMakeRequestWithBuilder:(WCServiceBuilder)builder callBack:(WCServiceCallBack)callBack;

@end
