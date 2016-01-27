//
//  NSObject+ServiceManager.m
//  ELottery
//
//  Created by sealedace on 13-11-28.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import "NSObject+ServiceManager.h"
#import "ServiceManager.h"
#import <objc/runtime.h>

static void *kObjectServiceKey = &kObjectServiceKey;

/**
 *  接口代理对象，用于接收请求响应，然后传给扩展的object
 *  这个对象方便处理dealloc事件
 */
@interface ELServiceObjectHelper : NSObject
@property (nonatomic, readonly) NSMutableDictionary *idDictionary;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
@property (nonatomic, weak) id <SerivceManagerDelegate> delegate;
#else
@property (nonatomic, assign) id <SerivceManagerDelegate> delegate;
#endif
@end

@implementation ELServiceObjectHelper

- (id)init
{
    self = [super init];
    if (self) {
        _idDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_idDictionary && _idDictionary.count > 0) {
        for (WebServiceID *sid in _idDictionary.allKeys) {
            [[ServiceManager sharedInstance] cancelRequestWithID:sid];
        }
    }
}

- (void)cleanService:(WebServiceID *)serviceID
{
    for (NSString *sid in _idDictionary.allKeys) {
        if ([sid isEqualToString:serviceID]) {
            [_idDictionary removeObjectForKey:sid];
            break;
        }
    }
    
    if (_idDictionary.count == 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ServiceManagerRequestFinishedNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ServiceManagerRequestFailedNotification object:nil];
    }
}

- (void)serviceRequestFinished:(NSNotification *)notification
{
    NSDictionary *userInfos = notification.object;
    BOOL bMyService = NO;
    for (NSString *sid in _idDictionary.allKeys) {
        if ([sid isEqualToString:userInfos[@"ServiceID"]]) {
            bMyService = YES;
            break;
        }
    }
    NSDictionary* userInfo = userInfos[@"userInfo"];
    if (!bMyService)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(service:callbackWithData:userInfo:)]) {
            [_delegate service:userInfos[@"ServiceID"] callbackWithData:userInfos[@"Response"] userInfo:userInfo];
        }
        [self cleanService:userInfos[@"ServiceID"]];
    });
}

- (void)serviceRequestFailed:(NSNotification *)notification
{
    NSDictionary *userInfos = notification.object;
    BOOL bMyService = NO;
    for (NSString *sid in _idDictionary.allKeys) {
        if ([sid isEqualToString:userInfos[@"ServiceID"]]) {
            bMyService = YES;
            break;
        }
    }
    
    if (!bMyService)
        return;
    NSDictionary* userInfo = userInfos[@"userInfo"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_delegate && [_delegate respondsToSelector:@selector(service:requestFailed:userInfo:)]) {
            [_delegate service:userInfos[@"ServiceID"] requestFailed:userInfos[@"Error"] userInfo:userInfo];
        }
        
        [self cleanService:userInfos[@"ServiceID"]];
    });
}


@end

@implementation NSObject (ServiceManager)

- (WebServiceID *)makeRequestForType:(WebServiceType)type params:(NSDictionary *)param method:(NSString*)method userInfo:(NSDictionary*)userInfo{
    ELServiceObjectHelper *serviceHelper = objc_getAssociatedObject(self, kObjectServiceKey);
    if (!serviceHelper) {
        serviceHelper = [[ELServiceObjectHelper alloc] init];
        serviceHelper.delegate = self;
        objc_setAssociatedObject(self, kObjectServiceKey, serviceHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (serviceHelper.idDictionary.count == 0){
        [[NSNotificationCenter defaultCenter] addObserver:serviceHelper selector:@selector(serviceRequestFinished:) name:ServiceManagerRequestFinishedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:serviceHelper selector:@selector(serviceRequestFailed:) name:ServiceManagerRequestFailedNotification object:nil];
    }
    if(!userInfo){
        userInfo = @{};
    }
    
    //针对type为ServiceType_Custom类型的网络请求 对userinfo加一个参数 用于ServiceDataAnalyze的解析判断
    if(type == ServiceType_Custom){
        userInfo = [NSDictionary addCustom1JsonAnalyze:userInfo];
    }
    
    WebServiceID *sid = [[ServiceManager sharedInstance] request:type param:param method:method userInfo:userInfo];
    if(sid){
        [serviceHelper.idDictionary setObject:[NSNumber numberWithInt:type] forKey:sid];
    }
    return sid;
}

//http://b.zhwnl.cn/api/auth/third_calendar/config

/**
 *  该方法针对请求参数中需要appSign的请求。
 */
- (WebServiceID *)makeRequestNeedAppSignForType:(WebServiceType)type params:(NSDictionary *)param method:(NSString*)method userInfo:(NSDictionary*)userInfo{
    [HttpRequestTool encryptAppSign:param];//param参数中添加一个md5加密的appSign
    return [self makeRequestForType:type params:param method:method userInfo:userInfo];
}


- (void)service:(WebServiceID *)serviceID requestFailed:(NSError *)error userInfo:(NSDictionary *)userInfo{
    
}

- (void)service:(WebServiceID *)serviceID callbackWithData:(id)data userInfo:(NSDictionary *)userInfo{
    
}

- (void)clearAllServices{
    ELServiceObjectHelper *serviceHelper = objc_getAssociatedObject(self, kObjectServiceKey);
    if(serviceHelper){
        for (WebServiceID *serviceId in serviceHelper.idDictionary.allKeys) {
            [[ServiceManager sharedInstance] cancelRequestWithID:serviceId];
        }
        [serviceHelper.idDictionary removeAllObjects];
    }
}

- (void)clearAllServicesWithType:(WebServiceType)type{
    ELServiceObjectHelper *serviceHelper = objc_getAssociatedObject(self, kObjectServiceKey);
    if(serviceHelper){
        
        NSArray* keys = [serviceHelper.idDictionary allKeysForObject:[NSNumber numberWithInt:type]];
        for (WebServiceID *serviceId in keys) {
            [[ServiceManager sharedInstance] cancelRequestWithID:serviceId];
        }
        [serviceHelper.idDictionary removeObjectsForKeys:keys];
    }
}

- (NSArray *)runningServices:(WebServiceType)type{
    ELServiceObjectHelper *serviceHelper = objc_getAssociatedObject(self, kObjectServiceKey);
    if (serviceHelper) {
        if (type == ServiceType_Invalid) {
            return serviceHelper.idDictionary.allKeys;
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for (WebServiceID *serviceId in serviceHelper.idDictionary.allKeys) {
                WebServiceType serviceType = [serviceHelper.idDictionary[serviceId] intValue];
                if (serviceType == type) {
                    [array addObject:serviceId];
                }
            }
            return array;
        }
    }
    return nil;
}

- (WebServiceType)getServiceTypeByID:(WebServiceID *)sid
{
    WebServiceType type = ServiceType_Invalid;
    ELServiceObjectHelper *serviceHelper = objc_getAssociatedObject(self, kObjectServiceKey);
    if (serviceHelper) {
        if ([serviceHelper.idDictionary objectForKey:sid]) {
            type = [[serviceHelper.idDictionary objectForKey:sid] intValue];
        }
    }
    return type;
}

@end
