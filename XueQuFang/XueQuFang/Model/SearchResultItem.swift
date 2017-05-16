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
		self.isXueXiao = true
	}
	
	init(item: SearchResultItem) {
		self.name = item.name
		self.id = item.id
		self.isXueXiao = item.isXueXiao
	}
	
	init(item_name:String, item_id:Int, item_isXueXiao:Bool)
	{
		self.name = item_name
		self.id = item_id
		self.isXueXiao = item_isXueXiao
	}
	
	init(item_name:String)
	{
		self.name = item_name
		self.id = -1
		self.isXueXiao = true
	}
	
	var name:String!
	var id:Int!
	var isXueXiao:Bool!
}
