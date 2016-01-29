//
//  GZYApiProxy.h
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/28.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GZYURLResponse.h"
#import "GZYRequestGenerator.h"

typedef void(^GZYNetCallback)(GZYURLResponse *response);

@interface GZYApiProxy : NSObject

+ (instancetype)sharedInstance;

-(NSNumber*)callApiWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier requestType:(GZYAPIRequestType)requestType success:(GZYNetCallback)success fail:(GZYNetCallback)fail;

- (NSNumber*)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(GZYNetCallback)success fail:(GZYNetCallback)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end

