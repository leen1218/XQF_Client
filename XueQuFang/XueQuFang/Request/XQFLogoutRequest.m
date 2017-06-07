//
//  XQFLogoutRequest.m
//  XueQuFang
//
//  Created by en li on 2017/6/1.
//  Copyright © 2017年 xqf. All rights reserved.
//

#import "XQFLogoutRequest.h"

@implementation XQFLogoutRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_GET;
		self.params = @{@"userID" : @"1"};
	}
	return self;
}

@end
