//
//  YGMessage.h
//  YGMessageDispatch
//
//  Created by 尹思同 on 2019/9/18.
//  Copyright © 2019 JRYGHQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGMessage : NSObject
@property (nonatomic, assign, getter=isProcessed) BOOL processed; //已被处理过
@property (nonatomic, strong) NSDictionary *msg_body;
@property (nonatomic, copy) NSString *msg_id;
@end

NS_ASSUME_NONNULL_END
