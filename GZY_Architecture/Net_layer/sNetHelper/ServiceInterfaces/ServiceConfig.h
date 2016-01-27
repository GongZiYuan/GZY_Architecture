//
//  ServiceConfig.h
//  ECalendar-Pro
//
//  Created by zhipeng ben on 15/7/23.
//  Copyright (c) 2015年 etouch. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 定义调试模式
 */
typedef enum : NSUInteger {
    WC_DebugModel_Test, //测试模式
    WC_DebugModel_Release //发布模式，正式地址
} WC_DebugModel;


extern NSString* WC_CustomBaseURL;


/**
 *  调试模式
 */
extern  NSInteger  WC_DebugModelValue;

extern  NSString*  const kWC_DebugModelValue;


@interface ServiceConfig : NSObject


/**
 *  保存当前的调试模式
 *
 *  @param model 当前的调试模式
 */
+ (void)saveCurrentDebugModel:(WC_DebugModel)model;

/**
 *  配置当前的调试模式
 *
 */
+ (void)configCurrentDebugModel;


+ (NSString*)baseURLForSuiShenYun;


+ (NSString*)baseURLForExplore;

/**
 *  @brief  搜索城市
 *
 *  @return url
 */
+ (NSString*)baseURLForSearchCity;

/**
 *  @brief  请求天气
 *
 *  @return url
 */
+ (NSString*)baseURLForWeather;

/**
 *  @brief  市场地址
 *
 *  @return url
 */
+ (NSString*)baseURLForMarketing;

/**
 *  国家节日地址
 *
 *  @return url
 */
+ (NSString*)baseURLForFestival;
@end
