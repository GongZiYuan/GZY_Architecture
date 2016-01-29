//
//  GZYAPIBaseManager.m
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/29.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import "GZYAPIBaseManager.h"
#import "GZYApiProxy.h"

@interface GZYAPIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) NSMutableDictionary *userInfoDic;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
//@property (nonatomic, readwrite) RTAPIManagerErrorType errorType;
@end

@implementation GZYAPIBaseManager

#pragma mark - getters and setters
- (NSMutableArray *)requestIdList{
    
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

-(NSMutableDictionary *)userInfoDic{
    if (_userInfoDic == nil) {
        _userInfoDic = [[NSMutableDictionary alloc] init];
    }
    return _userInfoDic;
}

- (BOOL)isReachable
{
//    BOOL isReachability = [AIFAppContext sharedInstance].isReachable;
//    if (!isReachability) {
//        self.errorType = RTAPIManagerErrorTypeNoNetWork;
//    }
//    return isReachability;
    return YES;
}

- (BOOL)isLoading{
    return [self.requestIdList count] > 0;
}

#pragma mark - life cycle
- (instancetype)init{
    self = [super init];
    if (self) {
//        _delegate = nil;
//        _validator = nil;
//        _paramSource = nil;
//        
//        _fetchedRawData = nil;
//        
//        _errorMessage = nil;
//        _errorType = RTAPIManagerErrorTypeDefault;
//        
//        if ([self conformsToProtocol:@protocol(RTAPIManager)]) {
//            self.child = (id <RTAPIManager>)self;
//        }
    }
    return self;
}

- (void)dealloc{
    [self cancelAllRequests];
    self.requestIdList = nil;
}


#pragma mark - calling api
- (NSNumber*)loadData
{
    NSDictionary *params = [self.paramSource requestParamsForApi:self];
    NSDictionary *userInfo = [self.paramSource userInfoParamsForApi:self];
    
    NSNumber *requestId = [self loadDataWithParams:params userInfo:userInfo];
    return requestId;
}

- (NSNumber*)loadDataWithParams:(NSDictionary *)params userInfo:(NSDictionary*)userInfo
{
    NSNumber *requestId = [NSNumber numberWithInteger:-1];
    
    // 先检查一下是否有缓存
//    if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
//        return 0;
//    }
    
    // 实际的网络请求
    if ([self isReachable]) {
                
       requestId = [[GZYApiProxy sharedInstance] callApiWithParams:params serviceIdentifier:nil requestType:1 success:^(GZYURLResponse *response) {
           [self successedOnCallingAPI:response];
       } fail:^(GZYURLResponse *response) {
           [self failedOnCallingAPI:response withErrorType:1];
       }];
        [self.requestIdList addObject:requestId];
        if (userInfo) {
            self.userInfoDic[requestId] = userInfo;
        }
       return requestId;
        
    } else {
//        [self failedOnCallingAPI:nil withErrorType:RTAPIManagerErrorTypeNoNetWork];
        return requestId;
    }

    return requestId;
}


- (void)successedOnCallingAPI:(GZYURLResponse *)response{
    if (response.responseString) {
        self.fetchedRawData = [response.responseString copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    [self.userInfoDic removeObjectForKey:response.requestId];
    if (YES) {
    
        [self.delegate managerCallAPIDidSuccess:self];
     
    } else {
       // [self failedOnCallingAPI:response withErrorType:1];
    }
}

- (void)failedOnCallingAPI:(GZYURLResponse *)response withErrorType:(NSInteger)errorType{
    
    [self removeRequestIdWithRequestID:response.requestId];
    [self.userInfoDic removeObjectForKey:response.requestId];
    [self.delegate managerCallAPIDidFailed:self];
}


#pragma mark - public methods
- (void)cancelAllRequests{
    [[GZYApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
    [self.userInfoDic removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSNumber*)requestID{
    [self removeRequestIdWithRequestID:requestID];
    [[GZYApiProxy sharedInstance] cancelRequestWithRequestID:requestID];
    [self.userInfoDic removeObjectForKey:requestID];
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSNumber*)requestId{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == [requestId integerValue]) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
@end
