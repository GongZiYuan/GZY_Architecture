//
//  HttpRequestTool.m
//  ELottery
//
//  Created by sealedace on 13-11-27.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import "HttpRequestTool.h"
#import "HttpRequestParam.h"
#import "ServiceDataAnalyze.h"
#import "ServiceConfig.h"
@implementation HttpRequestTool

static inline NSString * getSuishenyunAddress(NSString* suffix) {
    return [NSString stringWithFormat:@"%@%@", [ServiceConfig baseURLForSuiShenYun],suffix];
}

static inline NSString * getMarketingAddress(NSString* suffix) {
    return [NSString stringWithFormat:@"%@%@", [ServiceConfig baseURLForMarketing],suffix];
}


+ (NSString*)getApiAddressWithParams:(WebServiceType)type params:(NSDictionary*)params{

    NSString* address = nil;
    if(params && params.count > 0){
        switch (type){
            default:
                break;
        }
    }
    return [self getApiAddress:type];
}


+ (NSString *)getApiAddress:(WebServiceType)type{
    NSString *address = nil;
    
    switch (type) {
        default:
            break;
    }
    return address;
}

+ (NSString *)addParameters:(NSDictionary *)params toUrlString:(NSString *)url
{
    NSMutableString *sRet = [[NSMutableString alloc] initWithString:url];
    
    for(NSUInteger i=0; i<[params count]; i++){
        NSString *sKey = [params.allKeys objectAtIndex:i];
        NSString *sValue = params[sKey];
        if([sValue isKindOfClass:[NSNumber class]]){
            NSNumber *value = (NSNumber *)sValue;
            sValue = [value stringValue];
        }
        if(i==0){
            [sRet appendString:@"?"];
        }else{
            [sRet appendString:@"&"];
        }
        
        [sRet appendFormat:@"%@=%@", sKey, sValue];
    }
    return sRet;
}

+ (NSString*)getRequestUUID:(WebServiceType)serviceType param:(NSDictionary*)param userInfo:(NSDictionary*)userInfo{
    
    NSString* address = [[self class] getApiAddressWithParams:serviceType params:userInfo];
    NSMutableDictionary*  uuidParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [uuidParam addEntriesFromDictionary:userInfo];
    return [self addParameters:uuidParam toUrlString:address];
}

/**
 *  加密appSign
 *
 *  @param params 除了appSign的值
 *
 *  @return 添加appSign的值
 */
+(NSDictionary*)encryptAppSign:(NSDictionary*)params{
    NSArray * array = [params allKeys];
    SEL sel = @selector(compare:);
    array = [array sortedArrayUsingSelector:sel];
    NSMutableString * appSign = [NSMutableString string];
    for (int i = 0; i < array.count ; i++) {
        NSString * key = [array objectAtIndex:i];
        NSString * value = [params objectForKey:key];
        [appSign appendFormat:@"%@%@",key,value];
    }
//    [appSign appendFormat:@"%@",KSuishenyunAppSecret];
//    NSString * encryAppSign =  [EMoreTool md5:appSign];
//    [params setValue:encryAppSign forKey:@"app_sign"];
    return params;
}

@end



