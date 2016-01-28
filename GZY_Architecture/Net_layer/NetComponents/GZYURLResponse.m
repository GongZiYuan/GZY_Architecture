//
//  GZYURLResponse.m
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/28.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import "GZYURLResponse.h"

@interface GZYURLResponse (){
    
}

@property(nonatomic, strong) NSString *responseString;
@property(nonatomic, strong) NSNumber *requestId;
@property(nonatomic, strong) NSURLRequest *request;
@property(nonatomic, strong) NSData *responseData;
@property(nonatomic, assign) GZYURLResponseStatus responseStatus;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, strong) NSDictionary *userInfo;
@end


@implementation GZYURLResponse

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData userInfo:(NSDictionary*)userInfo status:(GZYURLResponseStatus)status{
    self = [super init];
    if (self) {
        self.responseString = responseString;
        self.requestId = requestId;
        self.request = request;
        self.responseData = responseData;
        self.responseStatus = status;
        self.userInfo = userInfo;
    }
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData userInfo:(NSDictionary*)userInfo error:(NSError*)error{
    self = [super init];
    if (self) {
        self.responseString = responseString;
        self.requestId = requestId;
        self.request = request;
        self.responseData = responseData;
        self.error = error;
        self.userInfo = userInfo;
    }
    return self;
}
@end
