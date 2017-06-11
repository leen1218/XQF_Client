//
//  MessageTVC.swift
//  XueQuFang
//
//  Created by en li on 2017/6/7.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation
import UIKit

class MessageTVC: UITableViewController
{
	// 这是一个通用的列表试图
	var itemType: String!  // "Message" : 消息列表, "City" : 城市选择列表
	
	// 目前支持的城市列表
	let city : [String] = ["杭州"]
	
	// Delegate
	var delegate: SearchMainVC!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (self.itemType == "Message")
		{
			return 0
		}
		else if (self.itemType == "City")
		{
			return self.city.count
		}
		return 0
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (self.itemType == "Message")
		{
			// TODO
			return super.tableView(tableView, cellForRowAt: indexPath)
		}
		else if (self.itemType == "City")
		{
			let cellId = "cell"
			var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
			
			if cell == nil
			{
				cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
			}
			
			cell?.selectionStyle = UITableViewCellSelectionStyle.none
			
			cell!.textLabel?.text = self.city[indexPath.row]
			return cell!
		}
		return super.tableView(tableView, cellForRowAt: indexPath)
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (self.itemType == "City")
		{
			self.delegate.tapCover()
		}
	}
}
