//
//  YGMessageCenter.h
//  YGMessageDispatch
//
//  Created by 尹思同 on 2019/9/18.
//  Copyright © 2019 JRYGHQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGMessageMonitor.h"
NS_ASSUME_NONNULL_BEGIN

@interface YGMessageCenter : NSObject

//单例
+ (instancetype)sharedInstance;

/**
 添加代理
 
 @param delegate 代理
 所有接收到的消息都会传给该delegate(如果消息未被栈顶delegate拦截)
 */
- (void)addDelegate:(id<YGMessageMonitorDelegate>)delegate;

/**
 移除代理
 
 @param delegate 代理
 */
- (void)removeDelegate:(id<YGMessageMonitorDelegate>)delegate;

/**
 根据keyPath-value添加代理
 
 @param delegate 代理
 @param condition keyPath-value
 如果condition.keyPath = nil,则所有接收到的消息都会传给该delegate(如果消息未被栈顶delegate拦截)
 如果condition.value = nil,则所有接收到的msg.keyPath下有值的消息,都会传给该delegate(如果消息未被栈顶delegate拦截)
 */
- (void)addDelegate:(id<YGMessageMonitorDelegate>)delegate condition:(YGMessageCondition)condition;

/**
 根据keyPath-value移除代理
 
 @param delegate 代理
 @param condition keyPath-value
 如果condition.keyPath = nil,则移除该代理,否则,移除指定的keyPath监听
 如果condition.value = nil,则移除keyPath的所有监听
 */
- (void)removeDelegate:(id<YGMessageMonitorDelegate>)delegate condition:(YGMessageCondition)condition;

- (void)postMessage:(YGMessage *)message;

@end

NS_ASSUME_NONNULL_END
