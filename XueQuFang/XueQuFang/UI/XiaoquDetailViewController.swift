//
//  XiaoquDetailViewController.swift
//  XueQuFang
//
//  Created by en li on 17/1/17.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation
class XiaoquDetailViewController: UIViewController {
	
	@IBOutlet weak var introImage: UIImageView!
	
	@IBOutlet weak var name: UILabel!
	// 小区信息
	@IBOutlet weak var xuequ_name: UILabel!
	@IBOutlet weak var xuequ_k: UILabel!
	@IBOutlet weak var xingzhenquyu: UILabel!
	@IBOutlet weak var xingzhengquyu_k: UILabel!
	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var address_k: UILabel!
	@IBOutlet weak var age: UILabel!
	@IBOutlet weak var age_k: UILabel!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var chuzhong_name: UILabel!
	@IBOutlet weak var chuzhong_k: UILabel!
	@IBOutlet weak var youeryuan_name: UILabel!
	@IBOutlet weak var youeryuan_k: UILabel!
	
	var model:HouseItem!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// UI
		self.setupUI()
		
	}
	
	func setupUI()
	{
		// 介绍图片
		self.introImage.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.3)
		let imageName = self.model.name + "_detail.jpg"
		XQFImageDownloadManager.shared().downloadImage(self.introImage, withName: imageName)
		
		// 学校名称
		self.name.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3, width: self.view.frame.width, height: 44)
		self.name.text = self.model.name
		
		// 小学学区
		self.xuequ_k.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3 + 44 + 5, width: self.view.frame.width , height: 44)
		self.xuequ_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.xuequ_k.textColor = UIColor.lightGray
		self.xuequ_name.frame = CGRect.init(x: 12 + self.view.frame.width * 0.2 + 5, y: self.view.frame.height * 0.3 + 44 + 5, width: self.view.frame.width, height: 44)
		self.xuequ_name.font = UIFont.boldSystemFont(ofSize: 16)
		self.xuequ_name.textColor = UIColor.black
		self.xuequ_name.text = self.model.xiaoxue["xiaoxue_name"] as? String
		
		// 初中学区
		self.chuzhong_k.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3 + (44 + 5) * 2, width: self.view.frame.width, height: 44)
		self.chuzhong_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.chuzhong_k.textColor = UIColor.lightGray
		self.chuzhong_name.frame = CGRect.init(x: 12 + self.view.frame.width * 0.2 + 5, y: self.view.frame.height * 0.3 + (44 + 5) * 2, width: self.view.frame.width, height: 44)
		self.chuzhong_name.font = UIFont.boldSystemFont(ofSize: 16)
		self.chuzhong_name.textColor = UIColor.black
		self.chuzhong_name.text = self.model.chuzhong["chuzhong_name"] as? String
		
		// 幼儿园学区
		self.youeryuan_k.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3 + (44 + 5) * 3, width: self.view.frame.width, height: 44)
		self.youeryuan_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.youeryuan_k.textColor = UIColor.lightGray
		self.youeryuan_name.frame = CGRect.init(x: 12 + self.view.frame.width * 0.2 + 5, y: self.view.frame.height * 0.3 + (44 + 5) * 3, width: self.view.frame.width, height: 44)
		self.youeryuan_name.font = UIFont.boldSystemFont(ofSize: 16)
		self.youeryuan_name.textColor = UIColor.black
		self.youeryuan_name.text = self.model.youeryuan["youeryuan_name"] as? String
		
		// 小区行政区域
		self.xingzhengquyu_k.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3 + (44 + 5) * 4, width: self.view.frame.width, height: 44)
		self.xingzhengquyu_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.xingzhengquyu_k.textColor = UIColor.lightGray
		self.xingzhenquyu.frame = CGRect.init(x: 12 + self.view.frame.width * 0.2 + 5, y: self.view.frame.height * 0.3 + (44 + 5) * 4, width: self.view.frame.width, height: 44)
		self.xingzhenquyu.font = UIFont.boldSystemFont(ofSize: 16)
		self.xingzhenquyu.textColor = UIColor.black
		self.xingzhenquyu.text = self.model.xingzhengquyu
		
		// 小区地址
		self.address_k.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3 + (44 + 5) * 5, width: self.view.frame.width, height: 44)
		self.address_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.address_k.textColor = UIColor.lightGray
		self.address.frame = CGRect.init(x: 12 + self.view.frame.width * 0.2 + 5, y: self.view.frame.height * 0.3 + (44 + 5) * 5, width: self.view.frame.width, height: 44)
		self.address.font = UIFont.boldSystemFont(ofSize: 16)
		self.address.textColor = UIColor.black
		self.address.text = self.model.detailAddress
		
		// 小区年代
		self.age_k.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3 + (44 + 5) * 6, width: self.view.frame.width, height: 44)
		self.age_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.age_k.textColor = UIColor.lightGray
		self.age.frame = CGRect.init(x: 12 + self.view.frame.width * 0.2 + 5, y: self.view.frame.height * 0.3 + (44 + 5) * 6, width: self.view.frame.width, height: 44)
		self.age.font = UIFont.boldSystemFont(ofSize: 16)
		self.age.textColor = UIColor.black
		self.age.text = self.model.age
		
		// 回退按钮
		self.backButton.frame = CGRect.init(x: 12, y: 12, width: 44, height: 44)
	}
	
	@IBAction func back(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
}
