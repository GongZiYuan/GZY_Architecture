//
//  ServiceConfig.m
//  ECalendar-Pro
//
//  Created by zhipeng ben on 15/7/23.
//  Copyright (c) 2015年 etouch. All rights reserved.
//

#import "ServiceConfig.h"


NSInteger WC_DebugModelValue = WC_DebugModel_Release;
NSString* const kWC_DebugModelValue = @"kWC_DebugModelValue";


NSString* WC_CustomBaseURL;

/**
 *  @brief  定义了一系列的接口基地址 这些地址不给外部直接访问 通过ServiceConfig统一获取和管理
 */

#ifdef  WeCalDebugModel         //测试地址

// 随身云UGC api 基址
NSString* const ServiceConfigReleaseURLForSuiShenYun_Overseas = @"http://debug.ecloud.im";
NSString* const ServiceConfigReleaseURLForSuiShenYun_China = @"http://b.zhwnl.cn";
// 随身云社区 api基址
NSString* const ServiceConfigReleaseURLForExplore_Overseas =  @"http://debug.ecloud.im/lizhi";
NSString* const ServiceConfigReleaseURLForExplore_China =  @"http://lz.ecloud.im/lizhi";

#else                           //线上地址

// 随身云UGC api 基址
NSString* const ServiceConfigReleaseURLForSuiShenYun_Overseas = @"http://client.ecloud.im";
NSString* const ServiceConfigReleaseURLForSuiShenYun_China = @"https://v2-client.suishenyun.cn";
//随身云社区 api基址
NSString* const ServiceConfigReleaseURLForExplore_Overseas =  @"http://lz.ecloud.im/lizhi";
NSString* const ServiceConfigReleaseURLForExplore_China =  @"http://client-lz.rili.cn/lizhi";

#endif

/**< 搜索城市*/
NSString* const ServiceConfigURLForSearchCity_Overseas = @"http://wxdata.weather.com";
NSString* const ServiceConfigURLForSearchCity_China = @"http://zhwnlapi.etouch.cn";
/**< 搜索天气*/
NSString* const ServiceConfigURLForWeather_Overseas = @"http://utilsvc.ecloud.im";
NSString* const ServiceConfigURLForWeather_China = @"http://zhwnlapi.etouch.cn";
/**< 市场地址*/
NSString* const ServiceConfigURLForMarketing = @"http://marketing.ecloud.im";

@implementation ServiceConfig

+ (WC_DebugModel)currentDebugModel{
    
#ifdef  WeCalDebugModel
    WC_DebugModel model = WC_DebugModelValue;
    return model;
#else
    return WC_DebugModel_Release;
#endif
}

+ (void)saveCurrentDebugModel:(WC_DebugModel)model{
    
    WC_DebugModelValue = model;
    [KUserStore setInteger:model forKey:kWC_DebugModelValue];
    [KUserStore synchronize];
    
    [[self class] configCurrentDebugModel];
}

+ (void)configCurrentDebugModel{
    
    WC_DebugModel model = [KUserStore integerForKey:kWC_DebugModelValue];
    WC_DebugModelValue = model;
}


+ (NSString*)baseURLForSuiShenYun{
        return ServiceConfigReleaseURLForSuiShenYun_China;
}

+ (NSString*)baseURLForExplore{

    return ServiceConfigReleaseURLForExplore_Overseas;

}

+ (NSString*)baseURLForSearchCity{
    return ServiceConfigURLForSearchCity_China;
}

+ (NSString*)baseURLForWeather{
    return ServiceConfigURLForWeather_China;
}

+ (NSString*)baseURLForMarketing{

    return ServiceConfigURLForMarketing;
}

+ (NSString *)baseURLForFestival{
    return ServiceConfigURLForWeather_Overseas;
}

@end
