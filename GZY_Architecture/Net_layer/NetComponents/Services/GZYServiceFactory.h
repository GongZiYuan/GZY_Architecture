//
//  GZYServiceFactory.h
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/29.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZYService.h"

@interface GZYServiceFactory : NSObject

+(instancetype)sharedInstance;

-(GZYService *)serviceWithIdentifier:(NSString *)identifier;
@end
