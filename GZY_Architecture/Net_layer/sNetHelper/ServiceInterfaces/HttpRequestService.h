//
//  HttpRequestService.h
//  ELottery
//
//  Created by sealedace on 13-11-27.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceDefinition.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLRequestSerialization.h"
/**
 *  Http请求的接口类
 
 不建议直接作为请求使用，使用ServiceManager进行管理请求
 */
@interface HttpRequestService : NSObject
{
    AFHTTPRequestOperation* requestOperation;
}

/**
 *  UUID，作为接口唯一标识
 */
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, unsafe_unretained) WebServiceType type;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
@property (nonatomic, weak) id <SerivceCallbackDelegate> delegate;
#else
@property (nonatomic, assign) id <SerivceCallbackDelegate> delegate;
#endif

- (id)initWithServiceType:(WebServiceType)serviceType param:(NSDictionary*)param delegate:(id<SerivceCallbackDelegate>)delegate userInfo:(NSDictionary*)userInfo;


/**
 *  发送请求 GET
 */
- (void)startRequest:(NSString*)method;

/**
 *  取消请求
 */
- (void)stop;

@end

