//
//  GZYServiceFactory.m
//  GZY_Architecture
//
//  Created by 赵远 on 16/1/29.
//  Copyright © 2016年 GongZiYuan. All rights reserved.
//

#import "GZYServiceFactory.h"

@interface GZYServiceFactory ()

@property(nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation GZYServiceFactory


#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static GZYServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GZYServiceFactory alloc] init];
    });
    return sharedInstance;
}


#pragma mark - public methods
- (GZYService *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (GZYService*)newServiceWithIdentifier:(NSString *)identifier
{
    return nil;
}

@end
