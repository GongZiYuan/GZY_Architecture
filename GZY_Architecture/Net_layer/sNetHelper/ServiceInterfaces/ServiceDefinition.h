//
//  ServiceDefinition.h
//  ELottery
//
//  Created by sealedace on 13-11-27.
//  Copyright (c) 2013年 eTouch. All rights reserved.
//



extern NSString * const ServiceManagerRequestFinishedNotification;
extern NSString * const ServiceManagerRequestFailedNotification;

/**
 *  接口类型枚举
 */
typedef NS_ENUM(NSInteger, WebServiceType){
    ServiceType_WeatherCitySearch,                 // 获取WeCal搜索城市
    ServiceType_StartLocation,                     // 定位完成之后的请求
    
    ServiceType_CountryList,                       // 国家列表
    
    ServiceType_Theme,                             //主题
    ServiceType_api_upgrade,                        //检测升级
    
    ServiceType_horoscope,                      // 获取星座
    ServiceType_Weather,                        // 获取天气
    ServiceType_WeatherHotCity,                 // 获取热门城市
    
    ServiceType_Custom,                         // 自定义接口（输入输出由外部控制）
    
    ServiceType_api_forum_posting,              // 发帖
    ServiceType_api_forum_share_stats,          //（帖子）分享成功统计
    
    ServiceType_api_forum_user_msg,             // 获取未读消息
    ServiceType_api_forum_delete_thread_msg,    // 删除消息
    ServiceType_api_forum_message_list,         // 消息列表
    ServiceType_api_forum_thread_reply,         // 回复消息
    ServiceType_api_forum_comments_list,        // 单个帖子的回复列表
    ServiceType_api_forum_thread_details,       // 帖子详情

    ServiceType_api_auth_login,                 //登录
    ServiceType_api_auth_oauthlogin,            //oauth登录
    ServiceType_api_auth_logout,                //注销
    ServiceType_api_auth_resetpwd_request,      //找回密码
    ServiceType_api_auth_verify_code,           //发送验证码
    ServiceType_api_auth_checkverify_code,      //校验验证码
    ServiceType_api_auth_v2_register,           //注册
    ServiceType_api_auth_resetpwd,              //手机注册重设密码
    ServiceType_api_auth_get_userinfo,          //获取用户信息
    ServiceType_api_auth_post_userinfo,         //上传用户信息
    ServiceType_api_auth_oauthbind,             //绑定邮箱账号
    ServiceType_api_auth_phonebind,             //已有账户绑定手机号
    ServiceType_api_auth_share_request,         //获取分享链接
    ServiceType_api_plisten,                    //设备注册
    ServiceType_api_bir_upnew,                  //上传手机号码和生日
    ServiceType_api_bir_qcloud,                 //获取生日
    ServiceType_api_auth_upload_preparing,      //获取上传密钥,
    ServiceType_api_v3_auth_sync_uid,            //4.2 新同步数据接口V2(new@2013/10/11)
    ServiceType_Invalid,
    
    //oauth
    ServiceType_api_getSinaToken,               //获取新浪token
    ServiceType_api_getSinaUserInfo,            //获取新浪用户信息
    ServiceType_api_getSinaGuanzhu,             //关注新浪微博
    ServiceType_api_getQQUserInfo,              //获取qq用户信息
    ServiceType_api_getWeixinToken,             //获取微信token
    ServiceType_api_getWeixinUserInfo           //获取微信用户信息
  
    
};

typedef NSString WebServiceID;

@protocol SerivceCallbackDelegate <NSObject>

/**
 *  请求回调 - 成功
 *
 *  @param serviceID 接口ID
 *  @param response  服务器响应的数据
 *  @param userInfo  用户信息
 *
 */
- (void)service:(WebServiceID *)serviceID requestFinished:(id)response userInfo:(NSDictionary*)userInfo;

/**
 *  请求回调 - 失败
 *
 *  @param serviceID 接口ID
 *  @param error     错误信息
 */
- (void)service:(WebServiceID *)serviceID requestFailed:(NSError*)error userInfo:(NSDictionary*)userInfo;

@end

@protocol SerivceManagerDelegate <NSObject>
- (void)service:(WebServiceID *)serviceID callbackWithData:(id)data userInfo:(NSDictionary*)userInfo;
- (void)service:(WebServiceID *)serviceID requestFailed:(NSError*)error userInfo:(NSDictionary*)userInfo;
@end



