//
//  ZNGJRegisterRequest.m
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "XQFSearchRequest.h"

@implementation XQFSearchRequest

-(instancetype)init
{
	if (self = [super init]) {
		self.requestType = ENUM_REQUEST_POST;
		self.params = @{@"searchText" : @"嘉绿苑小学"};
	}
	return self;
}

@end
