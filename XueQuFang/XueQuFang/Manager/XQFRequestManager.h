//
//  XQFRequestManager.h
//  XueQuFang
//
//  Created by en li on 16/5/10.
//  Copyright © 2016年 en li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQFRequest.h"

typedef enum {
	ENUM_REQUEST_TEST = 0,
	ENUM_REQUEST_SEARCH,
	ENUM_REQUEST_SCHOOL,
	ENUM_REQUEST_HOUSE,
	ENUM_REQUEST_LOGIN,
	ENUM_REQUEST_REGISTER,
	ENUM_REQUEST_AUTHENTICATION_CODE,
} EnumRequestType;

@interface XQFRequestManager : NSObject

// singleton
+(XQFRequestManager*) sharedManager;

// request factory
-(XQFRequest*) createRequest:(EnumRequestType) requestType;

@end
