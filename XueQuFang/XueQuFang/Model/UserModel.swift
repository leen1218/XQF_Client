//
//  UserModel.swift
//  XueQuFang
//
//  Created by en li on 2017/5/25.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class UserModel
{
	private init() {
		self.userID = -1
		self.token = ""
	}
	
	private static var model:UserModel? = nil
	
	public static func SharedUserModel() -> UserModel
	{
		if UserModel.model == nil
		{
			UserModel.model = UserModel()
		}
		return UserModel.model!
	}
	
	func setup(data:Dictionary<String, Any>)
	{
		if ((data["id"] as? Int) != nil)
		{
			self.userID = data["id"] as! Int
		}
		if ((data["token"] as? String) != nil)
		{
			self.token = data["token"] as! String
		}
	}
	
	var userID:Int!
	var token:String!
}

