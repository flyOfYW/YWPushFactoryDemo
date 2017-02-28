//
//  YWPushMethodProtocol.h
//  YWPushFactoryDemo
//
//  Created by yw on 2017/2/28.
//  Copyright © 2017年 yw. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YWPushMethodProtocol <NSObject>

/**
 iOS 10以上的收到远程推送通知的回调方法

 @param code  1-仅仅代表在前台收到信息，还没有开始点击消息*----*0-代表开始点击消息，不管app是运行在前台还是后台
 @param userInfo 通知内容
 */
- (void)getRemoteNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo;

/**
  iOS 10以上的收到本地推送通知的回调方法

 @param code code 1-仅仅代表在前台收到信息，还没有开始点击消息*----*0-代表开始点击消息，不管app是运行在前台还是后台
 @param userInfo 通知内容
 */
- (void)getLocalNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo;



@end
