//
//  NetGlobalData.h
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/27.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#ifndef NetGlobalData_h
#define NetGlobalData_h

typedef NS_ENUM(NSInteger, GZYURLResponseStatus){
    GZYURLResponseStatusSuccess = 1,
    GZYURLResponseStatusErrorTimeout,
    GZYURLResponseStatusErrorNoNetwork
};

typedef NS_ENUM(NSInteger, GZYAPIRequestType){
     GZYAPIRequestTypeGet = 1,
     GZYAPIRequestTypePost
};

static NSTimeInterval kGZYNetworkingTimeoutSeconds = 20.0f;
#endif /* NetGlobalData_h */
