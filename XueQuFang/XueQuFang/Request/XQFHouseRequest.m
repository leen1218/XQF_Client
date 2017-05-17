//
//  XQFHouseRequest.m
//  XueQuFang
//
//  Created by en li on 2017/5/17.
//  Copyright © 2017年 xqf. All rights reserved.
//

#import "XQFHouseRequest.h"

@implementation XQFHouseRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_GET;
		self.params = @{@"id" : @"1"};
	}
	return self;
}

@end
