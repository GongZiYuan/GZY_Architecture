//
//  HttpRequestService.m
//  ELottery
//
//  Created by sealedace on 13-11-27.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import "HttpRequestService.h"
#import "HttpRequestTool.h"

@interface HttpRequestService ()
- (void)start;
@property (nonatomic,assign) WebServiceType  serviceType;
@property (nonatomic,strong) NSDictionary*   param;
@property (nonatomic,strong) NSDictionary*   userInfo;
@end

@implementation HttpRequestService

- (void)dealloc{
    [self stop];
    requestOperation = nil;
}

- (id)initWithServiceType:(WebServiceType)serviceType param:(NSDictionary*)param delegate:(id<SerivceCallbackDelegate>)delegate userInfo:(NSDictionary*)userInfo{
    if(self = [super init]){
        self.param = param;
        self.delegate = delegate;
        self.serviceType = serviceType;
        self.userInfo  = userInfo;
    }
    return self;
}

- (void)startRequest:(NSString*)method{
    
    AFHTTPRequestSerializer* requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = nil;
    request = [requestSerializer requestWithMethod:method URLString:[HttpRequestTool getApiAddressWithParams:self.serviceType params:_userInfo] parameters:_param error:nil];

    request.timeoutInterval = 20;
    
    requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __weak __typeof(self)weakSelf = self;
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(service:requestFinished:userInfo:)]){
            [strongSelf.delegate service:strongSelf.uuid requestFinished:responseObject userInfo:strongSelf.userInfo];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(service:requestFailed:userInfo:)]){
            [strongSelf.delegate service:strongSelf.uuid requestFailed:error userInfo:strongSelf.userInfo];
        }
    }];
    [self start];
}


- (void)stop{
    if(requestOperation){
        [requestOperation setCompletionBlockWithSuccess:NULL failure:NULL];
        if(requestOperation.isExecuting){
            [requestOperation cancel];
        }
    }
}

#pragma mark - Private
- (void)start
{
    // 异步请求
    if(requestOperation){
        [requestOperation start];
    }
}

@end


