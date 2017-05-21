//
//  SearchResultItem.swift
//  XueQuFang
//
//  Created by en li on 2017/5/11.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation


class SearchResultItem
{
	init()
	{
		self.name = "default"
		self.id = -1
		self.type = "1"
	}
	
	init(item: SearchResultItem) {
		self.name = item.name
		self.id = item.id
		self.type = item.type
	}
	
	init(item_name:String, item_id:Int, item_type:String)
	{
		self.name = item_name
		self.id = item_id
		self.type = item_type
	}
	
	init(item_name:String)
	{
		self.name = item_name
		self.id = -1
		self.type = "1"
	}
	
	var name:String!
	var id:Int!
	var type:String!  // 不同搜索类型, 1. xiaoxue 2. xiaoqu 3. 培训机构
}
