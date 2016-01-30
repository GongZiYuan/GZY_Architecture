//
//  GZYCommonParamsGenerator.m
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/29.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import "GZYCommonParamsGenerator.h"
#import "GZYAppContext.h"

@implementation GZYCommonParamsGenerator

+ (NSDictionary *)commonParamsDictionary
{
    GZYAppContext *context = [GZYAppContext sharedInstance];
    return @{
             @"cid":context.cid,
             @"ostype2":context.ostype2,
             @"udid2":context.udid2,
             @"uuid2":context.uuid2,
             @"app":context.appName,
             @"cv":context.cv,
             @"from":context.from,
             @"m":context.m,
             @"macid":context.macid,
             @"o":context.o,
             @"pm":context.pm,
             @"qtime":context.qtime,
             @"uuid":context.uuid,
             @"i":context.i,
             @"v":context.v
             };
    return nil;
}
@end
