//
//  YGMessageMonitor.h
//  YGMessageDispatch
//
//  Created by 尹思同 on 2019/9/18.
//  Copyright © 2019 JRYGHQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGMessage.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct YGMessageCondition {
    NSString * _Nullable keyPath; //
    _Nullable id value;
} YGMessageCondition;

static inline YGMessageCondition YGMessageConditionMake(NSString * _Nullable keyPath, _Nullable id value) {
    YGMessageCondition condition;
    condition.keyPath = keyPath;
    condition.value = value;
    return condition;
}

@protocol YGMessageMonitorDelegate <NSObject>
@optional;

/**
 派发消息
 
 @param message 消息
 @param intercept 是否阻断消息继续发给其他订阅者
 */
- (void)didReceiveMessage:(YGMessage *)message intercept:(BOOL *)intercept;
@end

@interface YGMessageMonitor : NSObject
@property (nonatomic, weak) id<YGMessageMonitorDelegate> delegate; //代理
@property (nonatomic, assign) BOOL alwaysRespond; //总是响应所有消息
@property (nonatomic, assign, readonly) BOOL isInvalid; //是否无效，业务类型为0或者代理为空
- (void)addCondition:(YGMessageCondition)condition;
- (void)removeCondition:(YGMessageCondition)condition;
- (void)removeAllCondition;
- (BOOL)respondsToMessage:(YGMessage *)obj;
@end

NS_ASSUME_NONNULL_END
