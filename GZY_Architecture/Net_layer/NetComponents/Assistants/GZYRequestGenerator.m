//
//  GZYRequestGenerator.m
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/29.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import "GZYRequestGenerator.h"
#import "AFNetworking.h"
#import "NetGlobalData.h"
#import "GZYService.h"
#import "GZYSignatureGenerator.h"
#import "GZYCommonParamsGenerator.h"
#import "GZYServiceFactory.h"

@interface GZYRequestGenerator(){
    
}

@property(nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@end

@implementation GZYRequestGenerator


#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kGZYNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

#pragma mark - public methods
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static GZYRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GZYRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    
    GZYService *service = [[GZYServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    NSMutableDictionary *sigParams = [NSMutableDictionary dictionaryWithDictionary:requestParams];
 
    NSString *signature = [GZYSignatureGenerator signGetWithSigParams:sigParams methodName:methodName apiVersion:nil privateKey:nil publicKey:nil];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:[GZYCommonParamsGenerator commonParamsDictionary]];
    [allParams addEntriesFromDictionary:sigParams];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?%@&sig=%@", service.apiBaseUrl, service.apiVersion, methodName, nil, signature];
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    request.timeoutInterval = kGZYNetworkingTimeoutSeconds;
//    request.requestParams = requestParams;
//    [AIFLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"GET"];
    return request;
}

@end
