//
//  FactoryManager.m
//  YWPushFactoryDemo
//
//  Created by yw on 2017/2/28.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "FactoryManager.h"
/** 使用运行动态时，以免删除JPushFactory或者UMessageFactory报错 */
#import <objc/message.h>

@interface FactoryManager ()<YWPushMethodProtocol>

@end

@implementation FactoryManager

- (id<PushProtocol>)getJPushFactory:(NSDictionary *)launchOptions{
    
    Class c_ss = NSClassFromString(@"JPushFactory");

    id<PushProtocol> JPushF = [[c_ss alloc] initWithLaunchOptions:launchOptions];
    
    [self updateVariable:JPushF];

    return JPushF;
    
}

- (id<PushProtocol>)getUMessageFactory:(NSDictionary *)launchOptions{
    
    Class c_ss = NSClassFromString(@"UMessageFactory");

    id<PushProtocol> UM = [[c_ss alloc] initWithLaunchOptions:launchOptions];
    
    [self updateVariable:UM];

    return UM;
    
}

/**
 iOS 10以上的收到远程推送通知的回调方法
 
 @param code 1-代表app运行在前台 0-代表app运行在后台
 @param userInfo 通知内容
 */
- (void)getRemoteNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo{
    

    if ([self.delegate respondsToSelector:@selector(didRemoteNotificationAppStatues:withUserInfo:)]) {
        [self.delegate didRemoteNotificationAppStatues:code withUserInfo:userInfo];
    }
    
}

/**
 iOS 10以上的收到本地推送通知的回调方法
 
 @param code code 1-代表app运行在前台 0-代表app运行在后台
 @param userInfo 通知内容
 */
- (void)getLocalNotificationAppStatues:(NSInteger)code withUserInfo:(NSDictionary *)userInfo{
    
    if ([self.delegate respondsToSelector:@selector(didLocalNotificationAppStatues:withUserInfo:)]) {
        [self.delegate didLocalNotificationAppStatues:code withUserInfo:userInfo];
    }
}

/** 修改变量 */
- (id)updateVariable:(id<PushProtocol>)otherClass
{
    
    unsigned int count = 0;
    //获取属性列表
    Ivar *members = class_copyIvarList([otherClass class], &count);
    
    //遍历属性列表
    for (int i = 0 ; i < count; i++) {
        Ivar var = members[i];
        //获取变量名称
        const char *memberName = ivar_getName(var);
        //获取变量类型
        const char *memberType = ivar_getTypeEncoding(var);
        
        NSLog(@"%s----%s", memberName, memberType);
        
        Ivar ivar = class_getInstanceVariable([otherClass class], memberName);
        
        NSString *typeStr = [NSString stringWithCString:memberType encoding:NSUTF8StringEncoding];
        //判断类型
        if ([typeStr isEqualToString:@"@\"<YWPushMethodProtocol>\""]) {
            //修改值
            object_setIvar(otherClass, ivar, self);
        }
//        
//        else{
//            object_setIvar(otherClass, ivar, @"123");
//        }
    }
    return otherClass;
}



@end
