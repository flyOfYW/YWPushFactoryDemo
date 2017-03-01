//
//  AppDelegate.m
//  YWPushFactoryDemo
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "AppDelegate.h"
#import "FactoryManager.h"

@interface AppDelegate ()<FactoryManagerDelegate>

/** */
@property (nonatomic, copy) id<PushProtocol>factory;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    FactoryManager *manager = [FactoryManager new];
    
    manager.delegate = self;
    
    
    //    需要极光推送，把此注释打开，然后把友盟推送的代码注释掉，其余均不用操作
    //    _factory = [manager getJPushFactory:launchOptions];
    
    
    //    友盟推送
    _factory = [manager getUMessageFactory:launchOptions];
    
    
    return YES;
}
/**
 iOS 10以上的收到远程推送通知的回调方法
 
 @param code 1-仅仅代表在前台收到信息，还没有开始点击消息*----*0-代表开始点击消息，不管app是运行在前台还是后台
 @param userInfo 通知内容
 */
- (void)didRemoteNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo{
    
    if (code == 0) {
        
        NSLog(@"要开始点击推送消息了:%@", userInfo);
        
    }else if (code == 1){
        
        NSLog(@"刚收到推送消息了，还未开始点击:%@", userInfo);
        
    }
    
    
}
/**
 iOS 10以上的收到本地推送通知的回调方法
 
 @param code code 1-仅仅代表在前台收到信息，还没有开始点击消息*----*0-代表开始点击消息，不管app是运行在前台还是后台
 @param userInfo 通知内容
 */
- (void)didLocalNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo{
    
    if (code == 0) {
        
        NSLog(@"要开始点击推送消息了:%@", userInfo);
        
    }else if (code == 1){
        
        NSLog(@"刚收到推送消息了，还未开始点击:%@", userInfo);
        
    }
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [_factory handleRemoteNotification:userInfo];
    
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    [_factory handleRemoteNotification:userInfo];
    
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //    清除角标
    [_factory setApplicationBadgeNumber:application];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //    清除角标
    [_factory setApplicationBadgeNumber:application];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //    注册deviceToken
    [_factory registerDeviceToken:deviceToken];
    
}

@end
