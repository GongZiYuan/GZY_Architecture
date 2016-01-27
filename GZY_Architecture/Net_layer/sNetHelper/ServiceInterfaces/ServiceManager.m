//
//  ServiceManager.m
//  ELottery
//
//  Created by sealedace on 13-11-27.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import "ServiceManager.h"
#import "HttpRequestService.h"
#import "HttpRequestTool.h"


NSString * const ServiceManagerRequestFinishedNotification = @"ServiceManagerRequestFinishedNotification";
NSString * const ServiceManagerRequestFailedNotification =   @"ServiceManagerRequestFailedNotification";

@implementation ServiceManager

+ (ServiceManager *)sharedInstance{
    static ServiceManager *instance = nil;
    if(!instance){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[ServiceManager alloc] init];
        });
    }
    return instance;
}

- (id)init{
    self = [super init];
    if (self) {
        _servicesDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

- (WebServiceID *)request:(WebServiceType)serviceType param:(NSDictionary*)param method:(NSString*)method userInfo:(NSDictionary *)userInfo{
    NSString* serviceID =[HttpRequestTool getRequestUUID:serviceType param:param userInfo:userInfo];
    if(_servicesDictionary[serviceID]){
        return nil;
    }
    HttpRequestService *service = [[HttpRequestService alloc] initWithServiceType:serviceType param:param delegate:self userInfo:userInfo];
    service.uuid = serviceID;
    _servicesDictionary[service.uuid] = service;
    [service  startRequest:method];
    return service.uuid;
}

- (void)cancelRequestWithID:(NSString *)serviceID{
    if(!serviceID){
        return;
    }
    HttpRequestService *service = _servicesDictionary[serviceID];
    if(!service){
        return;
    }
    [_servicesDictionary removeObjectForKey:serviceID];
}

#pragma mark - ServiceDelegate
- (void)service:(WebServiceID *)serviceID requestFinished:(id)response userInfo:(NSDictionary *)userInfo{
    
    [ServiceDataAnalyzeManager analyzeWithData:response userInfo:userInfo paraserFinishedBlock:^(id data) {
        
        NSDictionary *userInfos = nil;
        NSString *errMessage = @"服务器错误";
        NSDictionary* result = nil;
        result = data;
        int  statusCode = [result[@"statusCode"] intValue];
        if(result[@"errorMessage"]){
            errMessage = result[@"errorMessage"];
        }
        NSDictionary* responseData = result[@"responseData"];
        if(statusCode == 1000){
            userInfos = @{@"ServiceID": serviceID,
                          @"Response": responseData,@"userInfo":userInfo};
        }else {
            NSError *error = [[NSError alloc] initWithDomain:errMessage code:statusCode userInfo:nil];
            userInfos = @{@"ServiceID":serviceID,@"Error":error,@"userInfo":userInfo};
        }
        
        
        if(statusCode == 1000){
            [[NSNotificationCenter defaultCenter] postNotificationName:ServiceManagerRequestFinishedNotification object:userInfos];
            NSLog(@"\n wecal requet success:%@",serviceID);
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:ServiceManagerRequestFailedNotification object:userInfos];
            NSLog(@"\n wecal requet failed:%@ \nand err:%@",serviceID,userInfos);
        }
        
        //add by nyz  invalidtoken 检测
        
            if (statusCode == 1004) {
                HttpRequestService *request  = [_servicesDictionary objectForKey:serviceID];
                WebServiceType sType = request.uuid;
                if (sType != ServiceType_api_auth_logout) {                        //退出接口的1004 不处理
                    NSLog(@"1004    sid:%@ ",serviceID);
                }
            }
        
        
        [_servicesDictionary removeObjectForKey:serviceID];
    }];

}


- (void)service:(NSString *)serviceID requestFailed:(NSError*)error userInfo:(NSDictionary *)userInfo{
    NSDictionary *userInfos = @{@"ServiceID":serviceID,@"Error":error,@"userInfo":userInfo};
    [[NSNotificationCenter defaultCenter] postNotificationName:ServiceManagerRequestFailedNotification object:userInfos];
    NSLog(@"\n wecal requet failed:%@ \nand err:%@",serviceID,userInfos);
    [_servicesDictionary removeObjectForKey:serviceID];
}

@end



