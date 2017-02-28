//
//  PushProtocol.h
//  YWPushFactoryDemo
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol PushProtocol <NSObject>

@optional
/**
 初始化

 @param launchOptions launchOptions
 @return 返回实体对象
 */
- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions;

/**
 清楚 Badge

 @param application application
 */
- (void)setApplicationBadgeNumber:(UIApplication *)application;

/**
 注册deviceToken

 @param deviceToken deviceToken
 */
- (void)registerDeviceToken:(NSData *)deviceToken;
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
- (void)handleRemoteNotification:(NSDictionary *)userInfo;

@end
