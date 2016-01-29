//
//  GZYRequestGenerator.h
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/29.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZYRequestGenerator : NSObject


+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
