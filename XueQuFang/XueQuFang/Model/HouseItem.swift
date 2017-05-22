//
//  HouseItem.swift
//  XueQuFang
//
//  Created by en li on 2017/5/22.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class HouseItem
{
	init()
	{
		self.name = "嘉绿北苑"
		self.id = -1
		self.city = "杭州"
		self.detailAddress = "华星路174号"
		self.type = "住宅区"
	}
	
	init(item: HouseItem) {
		self.name = item.name
		self.id = item.id
		self.city = item.city
		self.detailAddress = item.detailAddress
	}
	
	init(item_name:String, item_id:Int, item_city:String, item_detailAddress:String)
	{
		self.name = item_name
		self.id = item_id
		self.city = item_city
		self.detailAddress = item_detailAddress
	}
	
	
	var name:String!
	var city:String!
	var detailAddress:String!
	var id:Int!
	var type:String!
}
