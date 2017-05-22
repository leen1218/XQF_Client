//
//  SchoolItem.swift
//  XueQuFang
//
//  Created by en li on 2017/5/22.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class SchoolItem : BaseItem
{	
	init(item: SchoolItem) {
		super.init()
		
		self.name = item.name
		self.id = item.id
		self.city = item.city
		self.detailAddress = item.detailAddress
		self.polygons = item.polygons
		self.type = item.type
		self.xiaoqus = item.xiaoqus
	}
	
	init(item_name:String, item_id:Int, item_type:String, item_city:String, item_detailAddress:String, item_polygons:String)
	{
		super.init()
		
		self.name = item_name
		self.id = item_id
		self.city = item_city
		self.detailAddress = item_detailAddress
		self.polygons = item_polygons
		self.type = item_type
		self.xiaoqus = []
	}

	var polygons:String!
	var xiaoqus:[HouseItem]!
}
