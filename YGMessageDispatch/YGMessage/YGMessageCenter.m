//
//  YGMessageCenter.m
//  YGMessageDispatch
//
//  Created by 尹思同 on 2019/9/18.
//  Copyright © 2019 JRYGHQ. All rights reserved.
//

#import "YGMessageCenter.h"

@interface YGMessageCenter ()
@property (nonatomic, strong) NSMutableArray *monitorArray;
@property (nonatomic, strong) NSMutableArray *invalidMonitorArray;
@end

@implementation YGMessageCenter

+ (instancetype)sharedInstance {
    static YGMessageCenter *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YGMessageCenter alloc] init];
    });
    return manager;
}

- (void)postMessage:(YGMessage *)message {
    for (YGMessageMonitor *monitor in self.monitorArray.reverseObjectEnumerator) {
        if (monitor.isInvalid) {
            [self.invalidMonitorArray addObject:monitor];
            continue ;
        }
        BOOL responds = [monitor respondsToMessage:message];
        if (!responds) { continue ; }
        if ([monitor.delegate respondsToSelector:@selector(didReceiveMessage:intercept:)]) {
            BOOL intercept = NO;
            [monitor.delegate didReceiveMessage:message intercept:&intercept];
            if (intercept) { break ; }
        }
    }
    [self.monitorArray removeObjectsInArray:self.invalidMonitorArray];
    [self.invalidMonitorArray removeAllObjects];
}

- (void)addDelegate:(id<YGMessageMonitorDelegate>)delegate {
    if (delegate == nil) { return ; }
    //创建一个消息监听者，无条件的delegate，设置其监听者alwaysRespond为yes
    YGMessageMonitor *monitor = [self monitorForDelegate:delegate];
    if (monitor == nil) {
        monitor = [[YGMessageMonitor alloc] init];
        monitor.delegate = delegate;
        [self.monitorArray addObject:monitor];
    }else {
        //如果存在监听条件，则移除所有的监听条件，释放内存
        [monitor removeAllCondition];
    }
    monitor.alwaysRespond = YES;
}

- (void)removeDelegate:(id<YGMessageMonitorDelegate>)delegate {
    if (delegate == nil) { return ; }
    //移除消息监听者
    YGMessageMonitor *monitor = [self monitorForDelegate:delegate];
    if (monitor != nil) {
        [self.monitorArray removeObject:monitor];
    }
}

- (void)addDelegate:(id<YGMessageMonitorDelegate>)delegate condition:(YGMessageCondition)condition {
    if (delegate == nil) { return ; }
    //若condition.keypath为空，则设置该delegate为无条件
    if (condition.keyPath.length == 0) {
        [self addDelegate:delegate];
        return ;
    }
    YGMessageMonitor *monitor = [self monitorForDelegate:delegate];
    if (monitor == nil) {
        monitor = [[YGMessageMonitor alloc] init];
        monitor.delegate = delegate;
        [self.monitorArray addObject:monitor];
    }
    //若该代理已被设置为无条件监听者，则不再处理监听条件
    if (monitor.alwaysRespond) { return ;}
    [monitor addCondition:condition];
}

- (void)removeDelegate:(id<YGMessageMonitorDelegate>)delegate condition:(YGMessageCondition)condition {
    if (delegate == nil) { return ; }
    if (condition.keyPath.length == 0) {
        [self removeDelegate:delegate];
        return ;
    }
    YGMessageMonitor *monitor = [self monitorForDelegate:delegate];
    if (monitor == nil) { return ;}
    [monitor removeCondition:condition];
    if (monitor.isInvalid) {
        [self.monitorArray removeObject:monitor];
    }
}

- (YGMessageMonitor *)monitorForDelegate:(id<YGMessageMonitorDelegate>)delegate {
    NSMutableArray *invalidArray = [NSMutableArray array];
    YGMessageMonitor *monitor = nil;
    for (YGMessageMonitor *obj in self.monitorArray) {
        if (obj.delegate == delegate) {
            monitor = obj;
        }
        if (obj.delegate == nil) {
            [invalidArray addObject:obj];
        }
    }
    [self.monitorArray removeObjectsInArray:invalidArray];
    return monitor;
}

- (NSMutableArray *)monitorArray {
    if (_monitorArray == nil) {
        _monitorArray = [NSMutableArray array];
    }
    return _monitorArray;
}

- (NSMutableArray *)invalidMonitorArray {
    if (_invalidMonitorArray == nil) {
        _invalidMonitorArray = [NSMutableArray array];
    }
    return _invalidMonitorArray;
}

@end
