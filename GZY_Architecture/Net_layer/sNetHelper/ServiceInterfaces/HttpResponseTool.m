//
//  HttpResponseTool.m
//  ELottery
//
//  Created by sealedace on 13-11-28.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//

#import "HttpResponseTool.h"

@implementation HttpResponseTool

+ (id)parseResponse:(NSDictionary*)response withType:(WebServiceType)type{
    id ret = nil;
    switch(type){
        default:
            ret = response;
            break;
    }
    return ret;
}

+ (ResponseType)getResponseType:(WebServiceType)type{
    ResponseType rt = ResponseType_Json;
    return rt;
}

@end



