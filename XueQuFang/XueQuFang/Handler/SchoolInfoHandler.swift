//
//  SchoolInfoHandler.swift
//  XueQuFang
//
//  Created by en li on 2017/5/17.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class SchoolHandler: BaseHandler
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
				let schoolInfo = result_json?["schoolInfo"] as! Dictionary<String, Any>
				if schoolInfo["xuequ_polygon"] != nil
				{
//					let polygonPoints = self.delegate.getPointsFromPolygonString(schoolInfo["xuequ_polygon"] as! String)
//					self.delegate.drawPolygon(polygonPoints: polygonPoints)
//					self.delegate.searchXueXiao(name: schoolInfo["xiaoxue_name"] as! String, withType: "小学", withPolygon: polygonPoints)
//                    self.delegate.searchXueXiao(name: schoolInfo["xiaoxue_name"] as! String, withType: "小学", withPolygons: schoolInfo["xuequ_polygon"] as! String)
                    
                    // TODO: need to replace "杭州" with the real city from DB
                    self.delegate.searchXuexiao(address: schoolInfo["xiaoxue_name"] as! String, city: "杭州", withPolygons: schoolInfo["xuequ_polygon"] as! String)
				}
				else
				{
					showAlert(title: "学区片区未找到！", message: "您选择的小学学区信息暂未录库！", parentVC: self.delegate, okAction: nil)
				}
			}
			if (result_json?["status"] != nil && result_json?["status"] as! String == "401")
			{
				showAlert(title: "学校信息未找到！", message: "您选择的信息暂未找到！", parentVC: self.delegate, okAction: nil)
				return
			}
		}
	}
	
	override func onFailure(_ error: Error!) {
		showAlert(title: "查找失败！", message: "学校信息查找失败！", parentVC: self.delegate, okAction: nil)
	}
}
