//
//  ZNGJRequestManager.m
//  baoxincai
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "XQFRequestManager.h"
#import "XQFSearchRequest.h"

static XQFRequestManager* mSharedManager = nil;

NSString* const hostAPIURL = @"http://106.14.121.220:7600/%@";	// 云服务器
//NSString* const hostAPIURL = @"http://10.197.113.99:7600/%@";	//
//NSString* const hostAPIURL = @"http://localhost:7600/%@";

@interface XQFRequestManager()

@end

@implementation XQFRequestManager

+(XQFRequestManager*) sharedManager
{
	if (!mSharedManager) {
		mSharedManager = [[XQFRequestManager alloc] init];
	}
	
	return mSharedManager;
}

-(XQFRequest*) createRequest:(EnumRequestType)requestType
{
	XQFRequest* request = nil;
	switch (requestType) {
		case ENUM_REQUEST_SEARCH:
			request = [[XQFSearchRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAPIURL, @"search"];
			break;
		default:
			break;
	}
	
	return request;
}

@end
