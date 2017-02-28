//
//  UMessageFactory.m
//  YWPushFactoryDemo
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "UMessageFactory.h"

#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
//以下几个库仅作为调试引用引用的
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
//


@interface UMessageFactory ()<UNUserNotificationCenterDelegate>

@end

@implementation UMessageFactory

- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions{
    
    self = [super init];
    
    if (self) {
        
        [self initUMessage:launchOptions];
    }
    return self;
}

/**
 初始化UMessage
 
 @param launchOptions launchOptions
 */
- (void)initUMessage:(NSDictionary *)launchOptions{
    
    
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:app_Key launchOptions:launchOptions];
    
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
}

/**
 清除 Badge
 
 @param application application
 */
- (void)setApplicationBadgeNumber:(UIApplication *)application{
    //    推送
    [application setApplicationIconBadgeNumber:0];
    
    //    默认开启
    //    [UMessage setBadgeClear:YES]
    
}

/**
 注册deviceToken
 
 @param deviceToken deviceToken
 */
- (void)registerDeviceToken:(NSData *)deviceToken{
    
    
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    
    /** 若低于1.2.7版本,请将此处打开  */
    //    [UMessage registerDeviceToken:deviceToken];
    
}
/**
 iOS6以上，在iOS10没之前，需要在在以下的方法里调用这个方法
 - (void)application:(UIApplication *)application
 didReceiveRemoteNotification:(NSDictionary *)userInfo
 fetchCompletionHandler:
 (void (^)(UIBackgroundFetchResult))completionHandler
 和
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 
 @param userInfo userInfo
 */
- (void)handleRemoteNotification:(NSDictionary *)userInfo{
    
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
}

/**
 * 只有当应用程序位于前台时，该方法才会在委托上调用。如果方法未被执行或处理程序没有及时调用，则通知将不会被提交。
 * 应用程序可以选择将通知呈现为声音、徽章、警报和/或通知列表中。此决定应基于通知中的信息是否对用户可见
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0){
    
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        //       前台   ------     远程推送接受
        if([self.delegate respondsToSelector:@selector(getRemoteNotificationAppStatues:withUserInfo:)]){
            [self.delegate getRemoteNotificationAppStatues:1 withUserInfo:userInfo];
        }

    }else{
        //应用处于前台时的本地推送接受
        
        if([self.delegate respondsToSelector:@selector(getLocalNotificationAppStatues:withUserInfo:)]){
            [self.delegate getLocalNotificationAppStatues:1 withUserInfo:userInfo];
        }
        
    }
    
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
            if([self.delegate respondsToSelector:@selector(getRemoteNotificationAppStatues:withUserInfo:)]){
                
                [self.delegate getRemoteNotificationAppStatues:0 withUserInfo:userInfo];
            }
            
            
        }else{
            //应用处于后台时的本地推送接受
            if([self.delegate respondsToSelector:@selector(getLocalNotificationAppStatues:withUserInfo:)]){
                
                [self.delegate getLocalNotificationAppStatues:0 withUserInfo:userInfo];
                
            }
        }

}
@end
