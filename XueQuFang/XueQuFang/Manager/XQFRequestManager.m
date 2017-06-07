//
//  XQFRequestManager.m
//  XueQuFang
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import "XQFRequestManager.h"
#import "XQFSearchRequest.h"
#import "XQFSchoolRequest.h"
#import "XQFHouseRequest.h"
#import "XQFLoginRequest.h"
#import "XQFRegisterRequest.h"
#import "XQFAuthenticationCodeRequest.h"
#import "XQFLogoutRequest.h"

static XQFRequestManager* mSharedManager = nil;

NSString* const hostAPIURL = @"http://106.14.121.220:7600/%@";	// 云服务器
NSString* const hostAuthAPIURL = @"http://106.14.121.220:7600/auth/%@";
//NSString* const hostAPIURL = @"http://localhost:7600/%@";
//NSString* const hostAuthAPIURL = @"http://localhost:7600/auth/%@";

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
		case ENUM_REQUEST_SCHOOL:
			request = [[XQFSchoolRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAPIURL, @"school"];
			break;
		case ENUM_REQUEST_HOUSE:
			request = [[XQFHouseRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAPIURL, @"house"];
			break;
		case ENUM_REQUEST_LOGIN:
			request = [[XQFLoginRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthAPIURL, @"login"];
			break;
		case ENUM_REQUEST_REGISTER:
			request = [[XQFRegisterRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthAPIURL, @"register"];
			break;
		case ENUM_REQUEST_AUTHENTICATION_CODE:
			request = [[XQFAuthenticationCodeRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthAPIURL, @"message_auth"];
			break;
		case ENUM_REQUEST_LOGOUT:
			request = [[XQFLogoutRequest alloc] init];
			request.method = [NSString stringWithFormat:hostAuthAPIURL, @"logout"];
			break;
		default:
			break;
	}
	
	return request;
}

@end
