//
//  JPushFactory.m
//  YWPushFactoryDemo
//
//  Created by yw on 2017/2/28.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "JPushFactory.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>


@interface JPushFactory ()<JPUSHRegisterDelegate>

@end

@implementation JPushFactory


- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions{
    
    self = [super init];
    
    if (self) {
        
        [self initJPush:launchOptions];
    }
    return self;
}

- (void)initJPush:(NSDictionary *)launchOptions{
    
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:app_Key
                          channel:app_channel
                 apsForProduction:app_isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}


/**
 清除 Badge
 
 @param application application
 */
- (void)setApplicationBadgeNumber:(UIApplication *)application{
    //    极光推送
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}

- (void)registerDeviceToken:(NSData *)deviceToken{
    
    [JPUSHService registerDeviceToken:deviceToken];

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
    
    [JPUSHService handleRemoteNotification:userInfo];
    

}

/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
    
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        
        if([self.delegate respondsToSelector:@selector(getRemoteNotificationAppStatues:withUserInfo:)]){
            [self.delegate getRemoteNotificationAppStatues:1 withUserInfo:userInfo];
        }
        
        
    }
    else {
        // 判断为本地通知
//        NSLog(@"iOS10 前台收到本地通知:%@",userInfo);
        
        
        if([self.delegate respondsToSelector:@selector(getLocalNotificationAppStatues:withUserInfo:)]){
            [self.delegate getLocalNotificationAppStatues:1 withUserInfo:userInfo];
        }
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
    
    
}
/*
 * @brief handle UserNotifications.framework [didReceiveNotificationResponse:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param response 通知响应对象
 * @param completionHandler
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{

    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        
        [JPUSHService handleRemoteNotification:userInfo];
        
       
        if([self.delegate respondsToSelector:@selector(getRemoteNotificationAppStatues:withUserInfo:)]){
            
            [self.delegate getRemoteNotificationAppStatues:0 withUserInfo:userInfo];
        }
        
        
    }else{
        
        if([self.delegate respondsToSelector:@selector(getLocalNotificationAppStatues:withUserInfo:)]){
            
            [self.delegate getLocalNotificationAppStatues:0 withUserInfo:userInfo];
            
        }
        
    }
    completionHandler();  // 系统要求执行这个方法
    
    
}


// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


@end
