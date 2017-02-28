//
//  UMessageFactory.h
//  YWPushFactoryDemo
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushProtocol.h"
#import "YWPushMethodProtocol.h"

@interface UMessageFactory : NSObject<PushProtocol>

/** 代理--此处不能使用weak，因为此处的代理是动态时赋值，weak会提前释放*/
@property (nonatomic, copy) id<YWPushMethodProtocol>delegate;

@end
