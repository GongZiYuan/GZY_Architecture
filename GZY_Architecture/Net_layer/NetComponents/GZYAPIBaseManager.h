//
//  GZYAPIBaseManager.h
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/29.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GZYAPIBaseManager;

//api回调
@protocol GZYAPIManagerApiCallBackDelegate <NSObject>

@required
- (void)managerCallAPIDidSuccess:(GZYAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(GZYAPIBaseManager *)manager;

@end

//让manager能够获取调用API所需要的数据
@protocol GZYAPIManagerParamSourceDelegate <NSObject>

@required
- (NSDictionary *)requestParamsForApi:(GZYAPIBaseManager *)manager;

@optional

-(NSDictionary*)userInfoParamsForApi:(GZYAPIBaseManager*)manager;
@end

@interface GZYAPIBaseManager : NSObject

@property(nonatomic, weak) id<GZYAPIManagerParamSourceDelegate> paramSource;
@property(nonatomic, weak) id<GZYAPIManagerApiCallBackDelegate> delegate;

@end
