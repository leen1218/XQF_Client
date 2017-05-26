//
//  SchoolItem.swift
//  XueQuFang
//
//  Created by en li on 2017/5/22.
//  Copyright © 2017年 xqf. All rights reserved.
//


/////////////// 小学模型类
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
	
	init(school_data:Dictionary<String, Any>)
	{
		super.init()

		if ((school_data["xiaoxue_name"] as? String) != nil)
		{
			self.name = school_data["xiaoxue_name"] as! String
		}
		if school_data["id"] as? Int != nil
		{
			self.id = school_data["id"] as! Int
		}
		if school_data["xiangxidizhi"] as? String != nil
		{
			self.detailAddress = school_data["xiangxidizhi"] as! String
		}
		if school_data["xuequ_polygon"] as? String != nil
		{
			self.polygons = school_data["xuequ_polygon"] as! String
		}
		self.city = "杭州"
		self.type = "学校"
		self.xiaoqus = []
		if school_data["xiaoqus"] as? [Dictionary<String, Any>] != nil
		{
			// 解析学区房信息
			let xuequList = school_data["xiaoqus"] as! [Dictionary<String, Any>]
			for xiaoqu in xuequList
			{
				let houseItem = HouseItem.init(house_data: xiaoqu)
				self.xiaoqus.append(houseItem)
			}
		}
	}

	var polygons:String!
	var xiaoqus:[HouseItem]!
}
