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
	
	var model:HouseItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// UI
		self.setupUI()
		
	}
	
	func setupUI()
	{
		// 介绍图片
		self.introImage.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.3)
		
		// 学校名称
		self.name.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3, width: self.view.frame.width, height: 44)
		self.name.text = self.model.name
		
		// 小区学区
		self.xuequ_k.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3 + 44 + 5, width: self.view.frame.width * 0.15, height: 44)
		self.xuequ_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.xuequ_k.textColor = UIColor.lightGray
		self.xuequ_name.frame = CGRect.init(x: 12 + self.view.frame.width * 0.15 + 5, y: self.view.frame.height * 0.3 + 44 + 5, width: self.view.frame.width * 0.25, height: 44)
		self.xuequ_name.font = UIFont.boldSystemFont(ofSize: 16)
		self.xuequ_name.textColor = UIColor.black
		
		// 小区行政区域
		self.xingzhengquyu_k.frame = CGRect.init(x: 12 + self.view.frame.width * 0.5, y: self.view.frame.height * 0.3 + 44 + 5, width: self.view.frame.width * 0.2, height: 44)
		self.xingzhengquyu_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.xingzhengquyu_k.textColor = UIColor.lightGray
		self.xingzhenquyu.frame = CGRect.init(x: 12 + self.view.frame.width * 0.5 + self.view.frame.width * 0.2 + 5, y: self.view.frame.height * 0.3 + 44 + 5, width: self.view.frame.width * 0.25, height: 44)
		self.xingzhenquyu.font = UIFont.boldSystemFont(ofSize: 16)
		self.xingzhenquyu.textColor = UIColor.black
		
		// 小区地址
		self.address_k.frame = CGRect.init(x: 12, y: self.view.frame.height * 0.3 + 44 + 5 + 44 + 5, width: self.view.frame.width * 0.15, height: 44)
		self.address_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.address_k.textColor = UIColor.lightGray
		self.address.frame = CGRect.init(x: 12 + self.view.frame.width * 0.15 + 5, y: self.view.frame.height * 0.3 + 44 + 5 + 44 + 5, width: self.view.frame.width * 0.25, height: 44)
		self.address.font = UIFont.boldSystemFont(ofSize: 16)
		self.address.textColor = UIColor.black
		
		// 小区年代
		self.age_k.frame = CGRect.init(x: 12 + self.view.frame.width * 0.5, y: self.view.frame.height * 0.3 + 44 + 5 + 44 + 5, width: self.view.frame.width * 0.2, height: 44)
		self.age_k.font = UIFont.boldSystemFont(ofSize: 16)
		self.age_k.textColor = UIColor.lightGray
		self.age.frame = CGRect.init(x: 12 + self.view.frame.width * 0.5 + self.view.frame.width * 0.2 + 5, y: self.view.frame.height * 0.3 + 44 + 5 + 44 + 5, width: self.view.frame.width * 0.25, height: 44)
		self.age.font = UIFont.boldSystemFont(ofSize: 16)
		self.age.textColor = UIColor.black
		

	}
}
