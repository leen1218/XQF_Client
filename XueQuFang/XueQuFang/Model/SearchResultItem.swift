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
	}
	
	init(item_name:String)
	{
		self.name = item_name
	}
	
	var name:String!
}
