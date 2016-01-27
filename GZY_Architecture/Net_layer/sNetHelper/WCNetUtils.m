//
//  WCNetUtils.m
//  ECalendar-Pro
//
//  Created by nyz_star on 15/11/19.
//  Copyright © 2015年 etouch. All rights reserved.
//

#import "WCNetUtils.h"

@implementation WCServiceMaker

-(id)init{
    self = [super init];
    if (self) {
        self.isNeedAppSign = YES;
    }
    return self;
}

-(NSDictionary *)userInfo{
    if (_userInfo == nil) {
        return @{};
    }
    return _userInfo;
}

@end

@interface WCNetUtils ()

/**
 *  回调的callback 的 dic
 */
@property (nonatomic, readonly) NSMutableDictionary *callBackDic;

@end

@implementation WCNetUtils

-(id)init{
    self = [super init];
    if (self) {
        _callBackDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

-(void)dealloc{
    [_callBackDic removeAllObjects];
}

-(WebServiceID *)wcMakeRequestWithBuilder:(WCServiceBuilder)builder callBack:(WCServiceCallBack)callBack{
    if (builder == NULL) {
        return nil;
    }
    WCServiceMaker *maker = [[WCServiceMaker alloc] init];
    builder(maker);
    NSString *method = [self getNetRequestMethodWith:maker.method];
    if (method.length <= 0) {
        return nil;
    }
    WebServiceID *sid = nil;
    if (maker.isNeedAppSign) {
        sid = [self makeRequestNeedAppSignForType:maker.sType params:maker.param method:method userInfo:maker.userInfo];
    } else {
        sid = [self makeRequestForType:maker.sType params:maker.param method:method userInfo:maker.userInfo];
    }
    if (callBack != NULL && sid) {
        [_callBackDic setObject:[callBack copy] forKey:sid];
    }
    return sid;
}

-(void)service:(WebServiceID *)serviceID callbackWithData:(id)data userInfo:(NSDictionary *)userInfo{
    WCServiceCallBack callBack = [_callBackDic objectForKey:serviceID];
    if (callBack != NULL) {
        callBack(nil,data,userInfo);
    }
    [_callBackDic removeObjectForKey:serviceID];
}

-(void)service:(WebServiceID *)serviceID requestFailed:(NSError *)error userInfo:(NSDictionary *)userInfo{
    WCServiceCallBack callBack = [_callBackDic objectForKey:serviceID];
    if (callBack != NULL) {
        callBack(error,nil,userInfo);
    }
    [_callBackDic removeObjectForKey:serviceID];
}

- (NSString *)getNetRequestMethodWith:(NetRequestMethodType)method_type{
    NSString *methodStr = @"";
    switch (method_type) {
        case NetRequestMethodType_GET:
            methodStr = @"GET";
            break;
        case NetRequestMethodType_POST:
            methodStr = @"POST";
            break;
        default:
            break;
    }
    return methodStr;
}

@end
