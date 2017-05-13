//
//  SearchMainVC.swift
//  XueQuFang
//
//  Created by en li on 2017/5/11.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation
import UIKit

class SearchMainVC : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, RequestHandler
{
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 初始化UI
		self.setupUI()
	}
	
	var searchResultTV:UITableView!
	var searchbar:UISearchBar!
	
	var searchRecords = [SearchResultItem]()
	
	func setupUI()
	{
		// 搜索框
		let searchbarTop = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
		self.searchbar = UISearchBar.init(frame: CGRect.init(x: 0, y: searchbarTop, width: self.view.bounds.size.width, height: 44))
		self.searchbar.delegate = self
		self.view.addSubview(self.searchbar)
		
		// 搜索结果的TableView
		self.searchResultTV = UITableView.init()
		self.searchResultTV.translatesAutoresizingMaskIntoConstraints = false
		self.searchResultTV.delegate = self
		self.searchResultTV.dataSource = self
		self.searchResultTV.tableFooterView?.frame = CGRect.init()
		self.searchResultTV.isHidden = true // Invisible at initial
		self.view.addSubview(self.searchResultTV)
		
		// Left
		self.searchResultTV.translatesAutoresizingMaskIntoConstraints = false
		self.view.addConstraint(NSLayoutConstraint.init(item: self.searchResultTV, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0))
		// Top
		self.view.addConstraint(NSLayoutConstraint.init(item: self.searchResultTV, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.searchbar, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
		// Bottom
		self.view.addConstraint(NSLayoutConstraint.init(item: self.searchResultTV, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
		// Width
		self.view.addConstraint(NSLayoutConstraint.init(item: self.searchResultTV, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0))
		
		// TODO: Add Map View Here
	}
	
	// 向服务器发送搜索请求
	func search(searchText:String)
	{
		let request:XQFRequest = XQFRequestManager.shared().createRequest(ENUM_REQUEST_SEARCH)
		let params:Dictionary<String, String> = ["searchText":searchText]
		request.params = params
		request.handler = self
		request.start()
	}
	
// SearchBar Delegate
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.searchbar.showsCancelButton = true
		self.searchResultTV.isHidden = false
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if (searchBar.text == "") {
			return
		}
		self.search(searchText: searchText)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if (searchBar.text == "") {
			return
		}
		self.search(searchText: searchBar.text!)
		
		//
		self.searchbar.resignFirstResponder()
		self.searchbar.showsCancelButton = false
		self.searchbar.text = ""
		self.searchResultTV.isHidden = false
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		self.searchbar.resignFirstResponder()
		self.searchbar.showsCancelButton = true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.searchbar.resignFirstResponder()
		self.searchbar.showsCancelButton = false
		self.searchbar.text = ""
		self.searchResultTV.isHidden = true
	}

	
// Search Result TableView Delegate
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.searchRecords.count
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellId = "cell"
		var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
		
		if cell == nil
		{
			cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
		}

		cell!.textLabel?.text = self.searchRecords[indexPath.row].name
		return cell!
	}
	
// Search Request Delegate
	func onSuccess(_ response: Any!) {
		let result_json = response as? Dictionary<String, String>
		if (result_json != nil) {
			if (result_json?["msg"] != nil) {
				let msg = result_json?["msg"]
				print("服务器收到返回搜索请求!")
			}
		}
	}
	
	func onFailure(_ error: Error!) {
		print("搜索请求失败！")
	}
}
