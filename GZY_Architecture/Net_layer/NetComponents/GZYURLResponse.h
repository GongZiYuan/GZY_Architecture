//
//  GZYURLResponse.h
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/28.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetGlobalData.h"

@interface GZYURLResponse : NSObject

@property(nonatomic, strong, readonly) NSString *responseString;
@property(nonatomic, strong, readonly) NSNumber *requestId;
@property(nonatomic, strong, readonly) NSURLRequest *request;
@property(nonatomic, strong, readonly) NSData *responseData;
@property(nonatomic, assign, readonly) GZYURLResponseStatus responseStatus;
@property(nonatomic, strong, readonly) NSError *error;
@property(nonatomic, strong, readonly) NSDictionary *userInfo;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData userInfo:(NSDictionary*)userInfo status:(GZYURLResponseStatus)status;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData userInfo:(NSDictionary*)userInfo error:(NSError*)error;

@end
