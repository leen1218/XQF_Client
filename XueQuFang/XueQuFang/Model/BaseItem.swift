//
//  BaseItem.swift
//  XueQuFang
//
//  Created by en li on 2017/5/22.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class BaseItem
{
	init()
	{
		self.name = "嘉绿北苑"
		self.id = -1
		self.city = "杭州"
		self.detailAddress = "华星路174号"
		self.type = "住宅区"
	}
	
	var name:String!
	var city:String!
	var detailAddress:String!
	var id:Int!
	var type:String!
}
