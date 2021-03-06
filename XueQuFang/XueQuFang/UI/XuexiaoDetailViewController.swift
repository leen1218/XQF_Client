//
//  XuexiaoDetailViewController.swift
//  XueQuFang
//
//  Created by en li on 17/1/17.
//  Copyright © 2017年 en li. All rights reserved.
//

import Foundation
import UIKit

class XuexiaoDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	// UI
	@IBOutlet weak var introImage: UIImageView!
	@IBOutlet weak var xuexiaoName: UILabel!
	@IBOutlet weak var xuequTV: UITableView!
	@IBOutlet weak var backButton: UIButton!
	
	var model:SchoolItem!
	
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
		
		// 初始化UI
		self.setupUI()
		
		//TODO， 以后数据太大了，可以单独请求数据
		//self.setupModel()
	}
	
	func setupUI()
	{
		// 介绍图片
		self.introImage.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.3)
		let imageName = self.model.name + "_detail.jpg"
		//XQFImageDownloadManager.shared().downloadImage(self.introImage, withName: imageName)
		XQFImageDownloadManager.shared().downloadImage(self.introImage, withName: "启真名苑_detail.jpg")
		
		// 学校名称
		self.xuexiaoName.frame = CGRect.init(x: 10, y: self.view.frame.height * 0.3, width: self.view.frame.width, height: 44)
		self.xuexiaoName.text = self.model.name
		
		// 学区列表
		self.xuequTV.translatesAutoresizingMaskIntoConstraints = false
		self.xuequTV.rowHeight = 80
		self.xuequTV.delegate = self
		self.xuequTV.dataSource = self
		// Left
		self.view.addConstraint(NSLayoutConstraint.init(item: self.xuequTV, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0))
		// Top
		self.view.addConstraint(NSLayoutConstraint.init(item: self.xuequTV, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.xuexiaoName, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
		// Bottom
		self.view.addConstraint(NSLayoutConstraint.init(item: self.xuequTV, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
		// Width
		self.view.addConstraint(NSLayoutConstraint.init(item: self.xuequTV, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0))
		
		// 回退按钮
		self.backButton.frame = CGRect.init(x: 12, y: 12, width: 44, height: 44)
	}
	
	//MARK: XueQu TableView Delegate
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.model.xiaoqus.count
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellId = "XueQuFangCustomCell"
		var cell: XueQuFangCustomCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? XueQuFangCustomCell
		
		if cell == nil
		{
			cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId) as? XueQuFangCustomCell
		}
		
		cell!.XueQuFangAddress_L.text = self.model.xiaoqus[indexPath.row].detailAddress
		cell!.XueQuFangName_L.text = self.model.xiaoqus[indexPath.row].name
		//let xuequfangName = self.model.xiaoqus[indexPath.row].name + "_shortcut.jpg"
		//XQFImageDownloadManager.shared().downloadImage(cell!.XueQuFangShortcut_img, withName: xuequfangName)
		XQFImageDownloadManager.shared().downloadImage(cell!.XueQuFangShortcut_img, withName: "启真名苑_detail.jpg")
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XiaoquDetailVC")
		if let newVC = vc as? XiaoquDetailViewController {
			newVC.model = self.model.xiaoqus[indexPath.row]
			self.navigationController?.pushViewController(newVC, animated: true)
		}
	}
	
	@IBAction func back(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
}
