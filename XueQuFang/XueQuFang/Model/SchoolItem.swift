//
//  SchoolItem.swift
//  XueQuFang
//
//  Created by en li on 2017/5/22.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class SchoolItem
{
	init()
	{
		self.name = "嘉绿苑小学"
		self.id = -1
		self.city = "杭州"
		self.detailAddress = "华星路174号"
		self.type = "学校"
	}
	
	init(item: SchoolItem) {
		self.name = item.name
		self.id = item.id
		self.city = item.city
		self.detailAddress = item.detailAddress
		self.polygons = item.polygons
		self.type = item.type
	}
	
	init(item_name:String, item_id:Int, item_type:String, item_city:String, item_detailAddress:String, item_polygons:String)
	{
		self.name = item_name
		self.id = item_id
		self.city = item_city
		self.detailAddress = item_detailAddress
		self.polygons = item_polygons
		self.type = item_type
	}
	
	
	var name:String!
	var city:String!
	var polygons:String!
	var detailAddress:String!
	var id:Int!
	var type:String!
}
