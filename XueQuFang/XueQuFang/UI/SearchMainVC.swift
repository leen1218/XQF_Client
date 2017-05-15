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
		
		// 初始化数据
		self.setupModel()
	}
	
	// Search Bar
	var searchbar:UISearchBar!

	// Search Result TableView
	var searchResultTV:UITableView!
	let searchResultItemHeight:Int = 44
	let searchResultItemMaxCount = 10
	
	var searchRecords = [SearchResultItem]()
	var searchResults = [SearchResultItem]()
	var useSearchRecord:Bool!
	
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
		
		// Autolayout
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
	
	func setupModel()
	{
		// 搜索记录来自于沙盒数据
		guard let recordsSearchStr = UserDefaults.standard.string(forKey: "searchRecords") else {
			self.useSearchRecord = true
			return
		}
		let records:[String] = recordsSearchStr.components(separatedBy: ",")
		for record in records
		{
			self.searchRecords.append(SearchResultItem.init(item_name: record))
			self.useSearchRecord = true
		}
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
		if searchBar.text == ""
		{
			self.useSearchRecord = true
		}
		else
		{
			self.useSearchRecord = false
		}
		self.searchResultTV.reloadData()
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if (searchBar.text == "") {
			self.useSearchRecord = true
			self.searchResultTV.reloadData()
			return
		}
		self.useSearchRecord = false
		self.search(searchText: searchText)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if (searchBar.text == "") {
			return
		}
		self.search(searchText: searchBar.text!)
		
		// 更新search records
		self.updateSearchRecords(searchText: searchBar.text!)
		
		// 更新UI
		self.searchbar.resignFirstResponder()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		self.searchbar.resignFirstResponder()
		self.searchbar.showsCancelButton = false
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.searchbar.resignFirstResponder()
		self.searchbar.showsCancelButton = false
		self.searchbar.text = ""
		self.searchResultTV.isHidden = true
	}
	
	func updateSearchRecords(searchText:String)
	{
		for i in 0 ..< self.searchRecords.count {
			if self.searchRecords[i].name == searchText
			{
				if i > 0 {
					swap(&self.searchRecords[0], &self.searchRecords[i])
				}
				return
			}
		}
		self.searchRecords.insert(SearchResultItem.init(item_name: searchText), at: 0)
		if (self.searchRecords.count > 10) {
			self.searchRecords.removeLast()
		}
		var searchRecordsStr:String = self.searchRecords[0].name
		for i in 1 ..< self.searchRecords.count
		{
			searchRecordsStr += "," + self.searchRecords[i].name
		}
		UserDefaults.standard.set(searchRecordsStr, forKey: "searchRecords")
	}

	
// Search Result TableView Delegate
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (self.useSearchRecord)
		{
			return self.searchRecords.count
		}
		else
		{
			return self.searchResults.count
		}
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

		cell!.textLabel?.text = self.useSearchRecord! ? self.searchRecords[indexPath.row].name : self.searchResults[indexPath.row].name
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO : Go Server for selected item info
		let selectedItem = self.useSearchRecord! ? self.searchRecords[indexPath.row].name : self.searchResults[indexPath.row].name
		print("selected item : " + selectedItem!)
		
		// 添加search records
		self.updateSearchRecords(searchText: selectedItem!)
		
		// 更新UI
		self.searchbar.resignFirstResponder()
		self.searchbar.showsCancelButton = false
		self.searchbar.text = ""
		self.searchResultTV.isHidden = true
		
		self.useSearchRecord = true
	}
	
// Search Request Delegate
	func onSuccess(_ response: Any!) {
		let result_json = response as? Dictionary<String, Any>
		if (result_json != nil) {
			if (result_json?["status"] != nil && result_json?["status"] as! String == "200") {
				self.searchResults.removeAll()
				let searchResults = result_json?["data"] as! [String]
				for searchResult in searchResults
				{
					self.searchResults.append(SearchResultItem.init(item_name: searchResult))
				}
				self.searchResultTV.reloadData()
			}
			if (result_json?["status"] != nil && result_json?["status"] as! String == "201")
			{
				self.searchResults.removeAll()
				self.searchResults.append(SearchResultItem.init(item_name: result_json?["msg"] as! String))
				self.searchResultTV.reloadData()
			}
		}
		
	}
	
	func onFailure(_ error: Error!) {
		self.searchResults.append(SearchResultItem.init(item_name: "搜索请求失败！"))
		self.searchResultTV.reloadData()
	}
}
