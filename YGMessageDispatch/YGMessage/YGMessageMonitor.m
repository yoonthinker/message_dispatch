//
//  YGMessageMonitor.m
//  YGMessageDispatch
//
//  Created by 尹思同 on 2019/9/18.
//  Copyright © 2019 JRYGHQ. All rights reserved.
//

#import "YGMessageMonitor.h"
static NSString * const YGlwaysRespondValue = @"alwaysRespondValue";
@interface YGMessageMonitor ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *keyPathValueMaps;
@end
@implementation YGMessageMonitor

- (instancetype)init {
    if (self = [super init]) {
        self.alwaysRespond = NO;
    }
    return self;
}

- (BOOL)isInvalid {
    if (self.delegate == nil) {
        return YES;
    }
    if (self.alwaysRespond) {
        return NO;
    }
    return self.keyPathValueMaps.allKeys.count == 0;
}
- (BOOL)respondsToMessage:(YGMessage *)message {
    if (self.alwaysRespond) { return YES; }
    NSArray *keyPathArray = self.keyPathValueMaps.allKeys;
    for (NSString *keyPath in keyPathArray) {
        id value = [message valueForKeyPath:keyPath];
        if (value == nil) {
            return NO;
        }
        NSArray *valueArray = self.keyPathValueMaps[keyPath];
        for (id conditionValue in valueArray) {
            if (conditionValue == YGlwaysRespondValue) {
                return YES;
            }
            if ([value isKindOfClass:[NSString class]] && [conditionValue isKindOfClass:[NSString class]]) {
                if ([value isEqualToString:conditionValue]) {
                    return YES;
                }
            }
            if ([value isKindOfClass:[NSNumber class]] && [conditionValue isKindOfClass:[NSNumber class]]) {
                if ([value isEqualToNumber:conditionValue]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (NSMutableDictionary *)keyPathValueMaps {
    if (_keyPathValueMaps == nil) {
        _keyPathValueMaps = [NSMutableDictionary dictionary];
    }
    return _keyPathValueMaps;
}

- (NSMutableArray *)valueArrayForKeyPath:(NSString *)keyPath {
    NSMutableArray *array = self.keyPathValueMaps[keyPath];
    if (array == nil) {
        array = [NSMutableArray array];
        self.keyPathValueMaps[keyPath] = array;
    }
    return array;
}

- (void)addCondition:(YGMessageCondition)condition {
    //查找监听条件keypath下对照的value数组
    NSMutableArray *array = [self valueArrayForKeyPath:condition.keyPath];
    //若value为空，则监听该keypath下存在值的所有消息
    if (condition.value == nil) {
        condition.value = YGlwaysRespondValue;
    }
    [array addObject:condition.value];
}

- (void)removeCondition:(YGMessageCondition)condition {
    NSMutableArray *array = self.keyPathValueMaps[condition.keyPath];
    if (array == nil) { return ;}
    if (condition.value == nil) {
        condition.value = YGlwaysRespondValue;
    }
    [array removeObject:condition.value];
    if (array.count == 0) {
        [self.keyPathValueMaps removeObjectForKey:condition.keyPath];
    }
}

- (void)removeAllCondition {
    [self.keyPathValueMaps removeAllObjects];
}

@end
