//
//  BaseHandler.swift
//  XueQuFang
//
//  Created by en li on 2017/5/17.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation


class BaseHandler: NSObject, RequestHandler
{
	func onSuccess(_ response: Any!) {
	}
	
	func onFailure(_ error: Error!) {
	}
}
