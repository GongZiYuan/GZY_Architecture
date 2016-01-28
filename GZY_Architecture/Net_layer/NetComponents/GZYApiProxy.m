//
//  GZYApiProxy.m
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/28.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import "GZYApiProxy.h"

@interface GZYApiProxy ()

@property(nonatomic, strong) NSMutableDictionary *requestOperationTable;
@property(nonatomic, strong) NSMutableDictionary *userInfoTable;
@property(nonatomic, strong) NSNumber *recordedRequestId;

@property(nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end


@implementation GZYApiProxy

#pragma mark - getters and setters
- (NSMutableDictionary *)requestOperationTable{
    if (_requestOperationTable == nil) {
        _requestOperationTable = [[NSMutableDictionary alloc] init];
    }
    return _requestOperationTable;
}

- (AFHTTPRequestOperationManager *)operationManager{
    if (_operationManager == nil) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _operationManager;
}

-(NSMutableDictionary *)userInfoTable{
    if (_userInfoTable == nil) {
        _userInfoTable = [[NSMutableDictionary alloc] init];
    }
    return _userInfoTable;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static GZYApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GZYApiProxy alloc] init];
    });
    return sharedInstance;
}


- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    
    NSOperation *requestOperation = self.requestOperationTable[requestID];
    [requestOperation cancel];
    [self.requestOperationTable removeObjectForKey:requestID];
    [self.userInfoTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList{
    
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}


-(NSNumber*)callApiWithURLRequest:(NSURLRequest*)urlRequest success:(GZYNetCallback)successCallback fail:(GZYNetCallback)failCallback{
    
     NSNumber *requestId = [self generateRequestId];
    
    AFHTTPRequestOperation *requestOperation = [self.operationManager HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AFHTTPRequestOperation *storedOperation = self.requestOperationTable[requestId];
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.requestOperationTable removeObjectForKey:requestId];
        }
        
        //可以增加调试方法
        //打印一些信息。。。。
        
        GZYURLResponse *response = [[GZYURLResponse alloc] initWithResponseString:operation.responseString
                                                                        requestId:requestId
                                                                          request:operation.request
                                                                     responseData:operation.responseData
                                                                         userInfo:[self.userInfoTable objectForKey:requestId]
                                                                           status:GZYURLResponseStatusSuccess];
        [self.userInfoTable removeObjectForKey:requestId];
        
        successCallback ? successCallback(response) : nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        AFHTTPRequestOperation *storedOperation = self.requestOperationTable[requestId];
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.requestOperationTable removeObjectForKey:requestId];
        }
        
        GZYURLResponse *response = [[GZYURLResponse alloc] initWithResponseString:operation.responseString
                                                                        requestId:requestId
                                                                          request:operation.request
                                                                     responseData:operation.responseData
                                                                         userInfo:[self.userInfoTable objectForKey:requestId]
                                                                            error:error];
        
        [self.userInfoTable removeObjectForKey:requestId];
        failCallback ? failCallback(response) : nil;
    }];
    
    self.requestOperationTable[requestId] = requestOperation;
    [self.operationManager.operationQueue addOperation:requestOperation];
    
    return requestId;
}


- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

@end
