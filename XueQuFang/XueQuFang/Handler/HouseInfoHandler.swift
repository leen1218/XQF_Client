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
				let houseItem = HouseItem.init(item_name: houseInfo["xiaoqu_name"] as! String, item_id: houseInfo["id"] as! Int, item_city: "杭州", item_detailAddress: houseInfo["xiangxidizhi"] as! String)
				self.delegate.searchXiaoQu(name: houseInfo["xiaoqu_name"] as! String, inCity: "杭州", withType: "住宅区", detailAddress: houseInfo["xiangxidizhi"] as! String)
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
