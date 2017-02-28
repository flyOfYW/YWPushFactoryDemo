//
//  FactoryManager.h
//  YWPushFactoryDemo
//
//  Created by yw on 2017/2/28.
//  Copyright © 2017年 yw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushProtocol.h"
#import "YWPushMethodProtocol.h"


/**
 <NSObject>
 */
@protocol FactoryManagerDelegate<NSObject>


/**
 iOS 10以上的收到远程推送通知的回调方法
 
 @param code 1-仅仅代表在前台收到信息，还没有开始点击消息*----*0-代表开始点击消息，不管app是运行在前台还是后台
 @param userInfo 通知内容
 */
- (void)didRemoteNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo;
/**
 iOS 10以上的收到本地推送通知的回调方法
 
 @param code code 1-仅仅代表在前台收到信息，还没有开始点击消息*----*0-代表开始点击消息，不管app是运行在前台还是后台
 @param userInfo 通知内容
 */
- (void)didLocalNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo;

@end


@interface FactoryManager : NSObject

/** 代理*/
@property (nonatomic, weak) id<FactoryManagerDelegate>delegate;

/**
 获取极光推送的对象

 @param launchOptions launchOptions
 @return id<PushProtocol>
 */
- (id<PushProtocol>)getJPushFactory:(NSDictionary *)launchOptions;
/**
 获取友盟推送的对象
 
 @param launchOptions launchOptions
 @return id<PushProtocol>
 */
- (id<PushProtocol>)getUMessageFactory:(NSDictionary *)launchOptions;

@end
