//
//  YGMessage.m
//  YGMessageDispatch
//
//  Created by 尹思同 on 2019/9/18.
//  Copyright © 2019 JRYGHQ. All rights reserved.
//

#import "YGMessage.h"

@implementation YGMessage
- (instancetype)init {
    self = [super init];
    if (self) {
        _processed = NO;
    }
    return self;
}

- (BOOL)isProcessed {
    return _processed;
}
@end
