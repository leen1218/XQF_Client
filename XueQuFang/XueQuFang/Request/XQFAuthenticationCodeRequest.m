//
//  XQFAuthenticationCodeRequest.m
//  XueQuFang
//
//  Created by en li on 2017/5/25.
//  Copyright © 2017年 xqf. All rights reserved.
//

#import "XQFAuthenticationCodeRequest.h"

@implementation XQFAuthenticationCodeRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_GET;
		self.params = @{@"cellphone" : @"13616549781"};
	}
	return self;
}

@end
