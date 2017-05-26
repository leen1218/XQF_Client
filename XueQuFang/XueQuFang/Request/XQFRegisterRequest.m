//
//  XQFRegisterRequest.m
//  XueQuFang
//
//  Created by en li on 2017/5/25.
//  Copyright © 2017年 xqf. All rights reserved.
//

#import "XQFRegisterRequest.h"

@implementation XQFRegisterRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_POST;
		self.params = @{@"username" : @"13616549781", @"password" : @"123456"};
	}
	return self;
}

@end
