//
//  ViewController.m
//  YGMessageDispatch
//
//  Created by 尹思同 on 2019/9/18.
//  Copyright © 2019 JRYGHQ. All rights reserved.
//

#import "ViewController.h"
#import "YGMessageCenter.h"
@interface ViewController () <YGMessageMonitorDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YGMessageCondition condition;
//    condition = YGMessageConditionMake(@"msg_body.extra.nest.person.company.address", nil);
//    condition = YGMessageConditionMake(@"msg_body.extra",nil);
//    condition = YGMessageConditionMake(@"msg_body.extra.nest.person.company.address", @"花果山");
    condition = YGMessageConditionMake(@"msg_body.extra.nest.person.company.address", @"花果山水帘洞");
//    condition = YGMessageConditionMake(@"msg_body.extra.nest.person.gender", @"男");
//    condition = YGMessageConditionMake(@"msg_body.extra.nest.person.gender", @"女");
    [[YGMessageCenter sharedInstance] addDelegate:self condition:condition];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMessage:(YGMessage *)message intercept:(BOOL *)intercept {
    NSLog(@"%@", message.msg_body);
    message.processed = YES;
    *intercept = NO;
}

- (IBAction)sendMessageButtonClicked:(UIButton *)sender {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg" ofType:@"json"]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    YGMessage *message = [[YGMessage alloc] init];
    [message setValuesForKeysWithDictionary:dict];
    [[YGMessageCenter sharedInstance] postMessage:message];
}

@end
