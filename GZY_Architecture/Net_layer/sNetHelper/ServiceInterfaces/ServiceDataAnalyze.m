//
//  ServiceDataAnalyze.m
//  ECalendar-Pro
//
//  Created by B.E.N on 15/6/9.
//  Copyright (c) 2015年 etouch. All rights reserved.
//

#import "ServiceDataAnalyze.h"

NSString * const kServiceDataAnalyzeClassName = @"kServiceDataAnalyzeClassName";
NSString * const ServiceDataCustomJsonAnalyzeClassName_1 = @"ServiceDataCustom1JsonAnalyze";


@implementation NSDictionary (ServiceDataAnalyzer)

+ (NSDictionary*)addCustom1JsonAnalyze:(NSDictionary*)dic{
    
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:0];
    if(dic){
        [tmp addEntriesFromDictionary:dic];
    }
    tmp[kServiceDataAnalyzeClassName] = ServiceDataCustomJsonAnalyzeClassName_1;
    return [tmp copy];
    
}
@end


@implementation ServiceDataAnalyzeManager
+ (void)analyzeWithData:(NSData*)responseData userInfo:(NSDictionary*)userInfo paraserFinishedBlock:(ServiceDataAnalyzeManagerParaserFinishedBlock)paraserFinishedBlock{
    
    if(!responseData){
        paraserFinishedBlock(@{@"statusCode":@(-1)});
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        id result = nil;
        NSString* data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        ServiceDataType dataType = 0;
        NSError* error = nil;
        result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        if(!error){ //是json
            dataType = ServiceDataTypeJson;
        }else {
            result = data;
        }
        ServiceDataBaseAnalyze* analyze = nil;
        if(dataType == ServiceDataTypeJson){
            if(userInfo[kServiceDataAnalyzeClassName]){
                Class class = NSClassFromString(userInfo[kServiceDataAnalyzeClassName]);
                analyze = [[class alloc] init];
            }else {
                analyze = [[ServiceDataJsonAnalyze alloc] init];
            }
            
        }else {
            analyze = [[ServiceDataBaseAnalyze alloc] init];
        }
        
        
        NSDictionary* rs = [analyze serviceDataAnalyze:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            paraserFinishedBlock(rs);
        });
    });
}

@end

@implementation ServiceDataBaseAnalyze

- (NSDictionary*)serviceDataAnalyze:(id)responseData{
    
    NSDictionary* result = nil;
    result = @{@"responseData":responseData,@"statusCode":@(1000)};
    return result;
}
@end


@implementation ServiceDataJsonAnalyze

- (NSDictionary*)serviceDataAnalyze:(id)responseData{
    
    NSString *errMessage = @"服务器错误";
    NSDictionary* result = nil;
    NSInteger statusCode = -1;

    NSDictionary*  responseDic = (NSDictionary*)responseData;
    if([responseDic[@"status"] isKindOfClass:[NSNumber class]]){
        statusCode =  [responseDic[@"status"] intValue];
    } else if ([responseDic[@"status"] isKindOfClass:[NSString class]]){
        statusCode =  [responseDic[@"status"] intValue];
    }

    if(statusCode != 1000){
        NSString *sMessage = [NSString stringWithFormat:@"%@",responseDic[@"desc"]];
        if(sMessage && sMessage.length > 0){
            errMessage = sMessage;
        }
    }
    result = @{@"statusCode":@(statusCode),@"errorMessage":errMessage,@"responseData":responseData};
    return result;
}
@end


@implementation ServiceDataCustom1JsonAnalyze

- (NSDictionary*)serviceDataAnalyze:(NSData *)responseData{
    NSDictionary* result = nil;
    result = @{@"responseData":responseData,@"statusCode":@(1000)};
    return result;
}
@end
