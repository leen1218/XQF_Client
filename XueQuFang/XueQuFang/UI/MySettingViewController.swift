//
//  MySettingViewController.swift
//  XueQuFang
//
//  Created by en li on 2017/5/29.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

class MySettingViewController: UIViewController, RequestHandler{
	
	
	@IBOutlet weak var profile: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupUI()
	}
	
	func setupUI()
	{
		self.profile.frame = CGRect.init(x: self.view.frame.width / 2 - 30, y: 50, width: 60, height: 60)
		let imageName = "profiles/" + String(UserModel.SharedUserModel().userID!) + "_profile.jpg"
		XQFImageDownloadManager.shared().downloadImage(profile, withName: imageName)
	}
	
	@IBAction func logout(_ sender: UIButton) {
		let request:XQFRequest = XQFRequestManager.shared().createRequest(ENUM_REQUEST_LOGOUT)
		let params:Dictionary<String, String> = ["userID": String(UserModel.SharedUserModel().userID!)]
		request.params = params
		request.handler = self
		request.start()
	}
	
	func onSuccess(_ response: Any!) {
		let result_json = response as! Dictionary<String, Any>
		if (result_json["status"] != nil) {
			if (result_json["status"] as! String == "200") {
				// 1. 清除用户名，密码在本地数据存储
				UserDefaults.standard.removeObject(forKey: "username")
				UserDefaults.standard.removeObject(forKey: "password")
				UserDefaults.standard.removeObject(forKey: "autoLogin")
				
				// 2. 到客户登录界面
				let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
				let navigationVC = UINavigationController.init(rootViewController: loginVC)
				self.view.window?.rootViewController = navigationVC
				
			} else if (result_json["status"] as! String == "401") {
				showAlert(title: "手机号未注册", message:"手机号不存在，请注册！", parentVC: self, okAction: nil)
			}
		} else {
			showAlert(title: "请求失败", message:"请重新登录", parentVC: self, okAction: nil)
		}
	}
	func onFailure(_ error: Error!) {
		showAlert(title: "请求失败", message: "退出请求失败，请重试!", parentVC: self, okAction: nil)
	}
}
