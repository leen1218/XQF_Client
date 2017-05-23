//
//  HouseInfoHandler.swift
//  XueQuFang
//
//  Created by en li on 2017/5/17.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class HouseHandler: BaseHandler
{
	init(delegateVC: SearchMainVC) {
		super.init()
		self.delegate = delegateVC
	}
	
	weak var delegate:SearchMainVC!
	
	override func onSuccess(_ response: Any!) {
		let result_json = response as? Dictionary<String, Any>
		if (result_json != nil) {
			if (result_json?["status"] != nil && result_json?["status"] as! String == "200") {
				let houseInfo = result_json?["houseInfo"] as! Dictionary<String, Any>
				let houseItem = HouseItem.init(house_data: houseInfo)
				self.delegate.searchXiaoQu(houseItem)
			}
			if (result_json?["status"] != nil && result_json?["status"] as! String == "401")
			{
				showAlert(title: "学校信息未找到！", message: "您选择的信息暂未找到！", parentVC: self.delegate, okAction: nil)
				return
			}
		}
	}
	
	override func onFailure(_ error: Error!) {
		showAlert(title: "查找失败！", message: "小区信息查找失败！", parentVC: self.delegate, okAction: nil)
	}
}
