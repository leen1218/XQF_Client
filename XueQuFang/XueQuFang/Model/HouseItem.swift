//
//  HouseItem.swift
//  XueQuFang
//
//  Created by en li on 2017/5/22.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class HouseItem : BaseItem
{
	init(item: HouseItem) {
		super.init()
		
		self.name = item.name
		self.id = item.id
		self.city = item.city
		self.detailAddress = item.detailAddress
		self.type = item.type
		self.xiaoxue = item.xiaoxue
		self.chuzhong = item.chuzhong
		self.youeryuan = item.youeryuan
		self.xingzhengquyu = item.xingzhengquyu
		self.age = item.age
	}
	
	init(house_data:Dictionary<String, Any>)
	{
		super.init()
		
		self.name = house_data["xiaoqu_name"] as! String
		self.id = house_data["id"] as! Int
		self.city = "杭州"
		self.detailAddress = house_data["xiangxidizhi"] as! String
		self.type = "住宅区"
		self.xiaoxue = house_data["xiaoxue_info"] as! Dictionary<String, Any>
		self.chuzhong = house_data["chuzhong_info"] as! Dictionary<String, Any>
		self.youeryuan = house_data["youeryuan_info"] as! Dictionary<String, Any>
		self.xingzhengquyu = house_data["xingzhengquyu"] as! String
		self.age = house_data["jianzhuniandai"] as! String
	}
	
	var xiaoxue:Dictionary<String, Any>!
	var chuzhong:Dictionary<String, Any>!
	var youeryuan:Dictionary<String, Any>!
	var xingzhengquyu:String!
	var age:String!
}
