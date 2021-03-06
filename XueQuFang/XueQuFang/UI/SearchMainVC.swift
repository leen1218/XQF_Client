//
//  SearchMainVC.swift
//  XueQuFang
//
//  Created by en li on 2017/5/11.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation
import UIKit

class SearchMainVC : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, RequestHandler, MAMapViewDelegate, AMapSearchDelegate
{
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 初始化UI
		self.setupUI()
		
		// 初始化数据
		self.setupModel()
	}
	// Toolbar View
	var toolbar:UIView!
	
	// Search Bar
	var searchbar:UISearchBar!

	// Search Result TableView
	var searchResultTV:UITableView!
	let searchResultItemHeight:Int = 44
	let searchResultItemMaxCount = 10
    let defaultMapZoomLevel = 14.6
	
	var searchRecords = [SearchResultItem]()
	var searchResults = [SearchResultItem]()
	var useSearchRecord:Bool!
	
	// Map
    var mapView: MAMapView!
    var mapSearch: AMapSearchAPI!
    var mapCustomDelegate: MapCustomDelegate!
	
	// Setting panel
	var settingPanel: MySettingViewController!
	var coverPanel: UIView!
	
	// 消息界面
	var messagePanel: MessageTVC!
	
	// 城市选择界面
	var cityPanel: MessageTVC!
	
	// Request handler
	var schoolHandler: SchoolHandler!
	var houseHandler: HouseHandler!
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
//        mapView.delegate = self
        self.view.addSubview(mapView!)
        self.mapView.setZoomLevel(defaultMapZoomLevel, animated: true)
        
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint.init(item: self.mapView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0))
        // Top
        self.view.addConstraint(NSLayoutConstraint.init(item: self.mapView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.searchbar, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        // Bottom
        self.view.addConstraint(NSLayoutConstraint.init(item: self.mapView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
        // Width
        self.view.addConstraint(NSLayoutConstraint.init(item: self.mapView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0))
        
        // to current position
        AMapServices.shared().enableHTTPS = true
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
        
    }
    
    func initSearch() {
        mapSearch = AMapSearchAPI()
//        mapSearch.delegate = self
    }
    
    func initMapCustomDelegate() {
        mapCustomDelegate = MapCustomDelegate(delegateVC: self)
        self.mapView.delegate = mapCustomDelegate
        self.mapSearch.delegate = mapCustomDelegate
        
    }
	
	func setupUI()
	{
		// 顶部Toolbar效果, 用一张单独的UIView加上三个按钮空间实现
		// 高度 44
		let toolbarTop = UIApplication.shared.statusBarFrame.height
		self.toolbar = UIView.init(frame: CGRect.init(x: 0.0, y: toolbarTop, width: self.view.bounds.size.width, height: 44))
		self.toolbar.backgroundColor = UIColor.lightGray
		self.view.addSubview(self.toolbar)
		// 左: 个人设置
		let settingB = UIButton.init(frame: CGRect.init(x: 10, y: 10, width: 60, height:24))
		settingB.setTitle("个人", for: UIControlState.normal)
		settingB.addTarget(self, action: #selector(self.personalSettingTap), for: UIControlEvents.touchUpInside)
		self.toolbar.addSubview(settingB)
		
		// 中: 选择城市
		let cityB = UIButton.init(frame: CGRect.init(x: self.view.bounds.width / 2 - 40, y: 10, width: 60, height:24))
		cityB.setTitle("城市", for: UIControlState.normal)
		cityB.addTarget(self, action: #selector(self.cityTap), for: UIControlEvents.touchUpInside)
		self.toolbar.addSubview(cityB)
		
		// 右: 消息界面
		let messageB = UIButton.init(frame: CGRect.init(x: self.view.bounds.width - 70, y: 10, width: 60, height:24))
		messageB.setTitle("消息", for: UIControlState.normal)
		messageB.addTarget(self, action: #selector(self.messageTap), for: UIControlEvents.touchUpInside)
		self.toolbar.addSubview(messageB)
		
        // 搜索框
		let searchbarTop = UIApplication.shared.statusBarFrame.height + 44
		self.searchbar = UISearchBar.init(frame: CGRect.init(x: 0, y: searchbarTop, width: self.view.bounds.size.width, height: 44))
		self.searchbar.placeholder = "输入小学或者小区名称"
		self.searchbar.delegate = self
		self.view.addSubview(self.searchbar)
        
        // 地图
        initMapView()
        initSearch()
        initMapCustomDelegate()
		
		// 搜索结果的TableView
		self.searchResultTV = UITableView.init(frame: CGRect.init(x: 0, y: searchbarTop + 44, width: self.view.frame.width, height: self.view.frame.height - searchbarTop - 44))
		self.searchResultTV.translatesAutoresizingMaskIntoConstraints = false
		self.searchResultTV.delegate = self
		self.searchResultTV.dataSource = self
		self.searchResultTV.tableFooterView?.frame = CGRect.init()
		self.searchResultTV.isHidden = true // Invisible at initial
		self.view.addSubview(self.searchResultTV)
		
	}
	func personalSettingTap()
	{
		self.addCover()
		self.showSettingPanel()
	}
	func cityTap()
	{
		self.addCover()
		self.showCityPanel()
	}
	func messageTap()
	{
		self.addCover()
		self.showMessagePanel()
	}
	
	func addCover()
	{
		if self.coverPanel == nil
		{
			self.coverPanel = UIView.init(frame: self.view.frame)
			self.coverPanel.backgroundColor = UIColor.black
			self.coverPanel.alpha = 0.3
			self.view.addSubview(self.coverPanel)
			let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapCover))
			self.coverPanel.addGestureRecognizer(tap)
		}
		self.coverPanel.isHidden = false
	}
	func removeCover()
	{
		if self.coverPanel != nil
		{
			self.coverPanel.isHidden = true
		}
	}
	func tapCover()
	{
		// 1. 移除阴影封面
		self.removeCover()
		
		// 2. 收起个人设置界面
		self.hideSettingPanel()
		
		// 3. 收起消息界面
		self.hideMessagePanel()
		
		// 4. 收起城市选择界面
		self.hideCityPanel()
	}
	
	func showSettingPanel()
	{
		if (self.settingPanel == nil) {
			// 个人设置界面
			self.settingPanel = self.storyboard!.instantiateViewController(withIdentifier: "MySettingViewController") as! MySettingViewController
			self.addChildViewController(self.settingPanel)
			let toolbarTop = UIApplication.shared.statusBarFrame.height
			self.settingPanel.view.frame = CGRect.init(x: -self.view.frame.width * 2.0 / 3.0, y: toolbarTop, width: self.view.frame.width * 2.0 / 3.0, height: self.view.frame.height)
			self.view.addSubview(self.settingPanel.view)
		}
		
		UIView.animate(withDuration: 0.25, animations: {
			() -> Void in
			self.settingPanel.view.frame.origin.x = 0.0
			self.view.bringSubview(toFront: self.settingPanel.view)
		});
	}
	func hideSettingPanel()
	{
		if (self.settingPanel == nil)
		{
			return
		}
		
		UIView.animate(withDuration: 0.25, animations: {
			() -> Void in
			self.settingPanel.view.frame.origin.x = -self.view.frame.width * 2.0 / 3.0
		});
	}
	
	func showMessagePanel()
	{
		if (self.messagePanel == nil) {
			// 个人设置界面
			self.messagePanel = self.storyboard!.instantiateViewController(withIdentifier: "MessageTCV") as! MessageTVC
			self.messagePanel.delegate = self
			self.messagePanel.itemType = "Message"
			self.addChildViewController(self.messagePanel)
			let toolbarTop = UIApplication.shared.statusBarFrame.height
			self.messagePanel.view.frame = CGRect.init(x: self.view.frame.width, y: toolbarTop, width: self.view.frame.width * 2.0 / 3.0, height: self.view.frame.height)
			self.view.addSubview(self.messagePanel.view)
		}
		
		UIView.animate(withDuration: 0.25, animations: {
			() -> Void in
			self.messagePanel.view.frame.origin.x = self.view.frame.width / 3.0
			self.view.bringSubview(toFront: self.messagePanel.view)
		});
	}
	func hideMessagePanel()
	{
		if (self.messagePanel == nil)
		{
			return
		}
		
		UIView.animate(withDuration: 0.25, animations: {
			() -> Void in
			self.messagePanel.view.frame.origin.x = self.view.frame.width
		});
	}
	
	func showCityPanel()
	{
		if (self.cityPanel == nil) {
			// 城市选择界面
			self.cityPanel = self.storyboard!.instantiateViewController(withIdentifier: "MessageTCV") as! MessageTVC
			self.cityPanel.delegate = self
			self.cityPanel.itemType = "City"
			self.addChildViewController(self.cityPanel)
			let toolbarTop = UIApplication.shared.statusBarFrame.height
			self.cityPanel.view.frame = CGRect.init(x: self.view.frame.width / 6.0, y: toolbarTop + 44, width: self.view.frame.width * 2.0 / 3.0, height: self.view.frame.height)
			self.cityPanel.view.alpha = 0.0
			self.view.addSubview(self.cityPanel.view)
			self.cityPanel.view.isHidden = true
		}
		
		UIView.animate(withDuration: 0.25, animations: {
			() -> Void in
			self.cityPanel.view.alpha = 1.0
			self.view.bringSubview(toFront: self.cityPanel.view)
			self.cityPanel.view.isHidden = false
		});
	}
	func hideCityPanel()
	{
		if (self.cityPanel == nil)
		{
			return
		}
		
		UIView.animate(withDuration: 0.25, animations: { 
			() -> Void in
			self.cityPanel.view.alpha = 0.0
		}) { (finished) in
			self.cityPanel.view.isHidden = true
		}
	}
	
	func setupModel()
	{
		// 搜索记录来自于沙盒数据
		guard let searchRecordsSaved = UserDefaults.standard.array(forKey: "searchRecords") else {
			self.useSearchRecord = true
			return
		}
		for searchRecordSaved in searchRecordsSaved
		{
			var searchRecord = searchRecordSaved as! Dictionary<String, Any>
			self.searchRecords.append(SearchResultItem.init(item_name: searchRecord["name"] as! String, item_id: searchRecord["id"] as! Int, item_type: searchRecord["type"] as! String))
			self.useSearchRecord = true
		}
	}
	
	//Mark: Request for Server
	//搜索请求
	func search(searchText:String)
	{
		let request:XQFRequest = XQFRequestManager.shared().createRequest(ENUM_REQUEST_SEARCH)
		let params:Dictionary<String, String> = ["searchText":searchText]
		request.params = params
		request.handler = self
		request.start()
	}
	//学校信息请求
	func xiaoxueInfo(xiaoxueId:Int)
	{
		let request:XQFRequest = XQFRequestManager.shared().createRequest(ENUM_REQUEST_SCHOOL)
		let params:Dictionary<String, String> = ["id":String(xiaoxueId), "userID":String(UserModel.SharedUserModel().userID!), "token":UserModel.SharedUserModel().token!]
		request.params = params
		self.schoolHandler = SchoolHandler(delegateVC: self)
		request.handler = self.schoolHandler
		request.start()
	}
	
	//小区信息请求
	func xiaoquInfo(xiaoquId:Int)
	{
		let request:XQFRequest = XQFRequestManager.shared().createRequest(ENUM_REQUEST_HOUSE)
		let params:Dictionary<String, String> = ["id":String(xiaoquId), "userID":String(UserModel.SharedUserModel().userID!), "token":UserModel.SharedUserModel().token!]
		request.params = params
		self.houseHandler = HouseHandler(delegateVC: self)
		request.handler = self.houseHandler
		request.start()
	}
	
	//MARK: SearchBar Delegate
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.searchbar.setShowsCancelButton(true, animated: true)
		//self.searchbar.showsCancelButton = true
		self.searchResultTV.isHidden = false
		if (searchBar.text == "") {
			self.useSearchRecord = true
		} else {
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
	
	func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		var inputText:String = searchBar.text!
		if range.length == 0  // 新输入拼音
		{
			inputText += text
		}
		else  // 删除拼音
		{
			let nsString = searchBar.text as NSString?
			inputText = (nsString?.replacingCharacters(in: range, with: text))!
		}
		inputText = inputText.replacingOccurrences(of: " ", with: "")  // replace char is not a space!!!
		
		if (inputText == "") {
			self.useSearchRecord = true
			self.searchResultTV.reloadData()
			return true
		}
		
		// Search from server
		self.search(searchText: inputText)
		return true
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if (searchBar.text == "") {
			return
		}
		self.search(searchText: searchBar.text!)
		
		// 更新UI
		self.searchbar.resignFirstResponder()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		self.searchbar.resignFirstResponder()
		//self.searchbar.showsCancelButton = false
		self.searchbar.setShowsCancelButton(false, animated: true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.searchbar.resignFirstResponder()
		//self.searchbar.showsCancelButton = false
		self.searchbar.setShowsCancelButton(false, animated: true)
		self.searchbar.text = ""
		self.searchResultTV.isHidden = true
	}
	
	func updateSearchRecords(searchItem:SearchResultItem)
	{
		var isUpdate = false
		for i in 0 ..< self.searchRecords.count {
			if self.searchRecords[i].name == searchItem.name
			{
				self.searchRecords.remove(at: i)
				self.searchRecords.insert(SearchResultItem.init(item:searchItem), at: 0)
				isUpdate = true
				break
			}
		}
		if isUpdate == false
		{
			self.searchRecords.insert(SearchResultItem.init(item:searchItem), at: 0)
			if (self.searchRecords.count > 10) {
				self.searchRecords.removeLast()
			}
		}
		// Save searchRecords into UserDefault
		var searchRecordSaved = [Dictionary<String, Any>]()
		for i in 0 ..< self.searchRecords.count
		{
			var searchRecord = Dictionary<String, Any>()
			searchRecord["name"] = self.searchRecords[i].name
			searchRecord["id"] = self.searchRecords[i].id
			searchRecord["type"] = self.searchRecords[i].type
			searchRecordSaved.append(searchRecord)
		}
		UserDefaults.standard.set(searchRecordSaved, forKey: "searchRecords")
	}

	
	//MARK: Search Result TableView Delegate
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (self.useSearchRecord == true)
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
		let selectedItem = self.useSearchRecord! ? self.searchRecords[indexPath.row] : self.searchResults[indexPath.row]
		// request for selected item info
		if selectedItem.type == "1"  // Search XueXiao
		{
			self.xiaoxueInfo(xiaoxueId: selectedItem.id)
		}
		else if selectedItem.type == "2"  // Search XiaoQu
		{
			self.xiaoquInfo(xiaoquId: selectedItem.id)
		}
		else
		{
			// TODO : 培训机构
		}
		// 添加search records
		self.updateSearchRecords(searchItem: selectedItem)
		
		// 更新UI
		self.searchbar.resignFirstResponder()
		self.searchbar.setShowsCancelButton(false, animated: true)
		//self.searchbar.showsCancelButton = false
		self.searchbar.text = ""
		self.searchResultTV.isHidden = true
		
		self.useSearchRecord = true
	}
	
	//MARK: Search Request Delegate
	func onSuccess(_ response: Any!) {
		let result_json = response as? Dictionary<String, Any>
		if (result_json != nil) {
			if (result_json?["status"] != nil && result_json?["status"] as! String == "200") {
				self.searchResults.removeAll()
				let searchResults = result_json?["data"] as! [Dictionary<String, Any>]
				for searchResult in searchResults
				{
					self.searchResults.append(SearchResultItem.init(item_name: searchResult["name"] as! String, item_id: searchResult["id"] as! Int, item_type: searchResult["type"] as! String))
				}
				self.useSearchRecord = false
				self.searchResultTV.reloadData()
			}
			if (result_json?["status"] != nil && result_json?["status"] as! String == "201")
			{
				self.searchResults.removeAll()
				self.searchResults.append(SearchResultItem.init(item_name: result_json?["msg"] as! String))
				self.useSearchRecord = false
				self.searchResultTV.reloadData()
			}
		}
	}
	
	func onFailure(_ error: Error!) {
		self.useSearchRecord = false
		self.searchResults.removeAll()
		self.searchResults.append(SearchResultItem.init(item_name: "搜索请求失败！"))
		self.searchResultTV.reloadData()
	}
    
	//MARK: Map Search API
    func searchXiaoQu(_ houseItem: HouseItem) {
        self.clearAnnotationsAndOverlays()
        self.mapView.setZoomLevel(defaultMapZoomLevel, animated: true)
        
        let request = CustomPOIKeywordsSearchRequest()
        request.keywords = houseItem.name
        request.requireExtension = true
        request.types = houseItem.type
        request.city = houseItem.city
        request.baseItem = houseItem
        
        request.cityLimit = true
        request.requireSubPOIs = true
        mapSearch.aMapPOIKeywordsSearch(request)
    }
    
    func searchXuexiao(_ schoolItem: SchoolItem) {
        self.clearAnnotationsAndOverlays()
        
        let polygonList = getPointsListFromPolygonString(schoolItem.polygons)
        self.drawPolygonList(polygonList: polygonList)
        
        let request = CustomPOIKeywordsSearchRequest()
        request.keywords = schoolItem.detailAddress
        request.requireExtension = true
        request.types = schoolItem.type
        request.city = schoolItem.city
        request.baseItem = schoolItem
        
        request.cityLimit = true
        request.requireSubPOIs = true
        mapSearch.aMapPOIKeywordsSearch(request)
        
//        self.mapView.setZoomLevel(defaultMapZoomLevel, animated: true)
//        let request = CustomGeocodeSearchRequest()
//        request.address = name
//        request.city = city
//        request.detailAddress = detailAddress
//        mapSearch.aMapGeocodeSearch(request)
    }
    
    //deprecate method
//    private func searchXueXiao(name xueXiao: String, withType type: String, withPolygons polygons: String) {
//        self.clearAnnotationsAndOverlays()
//        
//        let polygonList = getPointsListFromPolygonString(polygons)
//        self.drawPolygonList(polygonList: polygonList)
//        
//        // search with polygon[0], need to make sure the school is in the first polygon
//        let request = AMapPOIPolygonSearchRequest()
//        var points = Array<AMapGeoPoint>.init()
//        for p in polygonList[0] {
//            points.append(AMapGeoPoint.location(withLatitude: p.y, longitude: p.x))
//        }
//        request.polygon = AMapGeoPolygon.init(points: points)
//        
//        request.keywords            = xueXiao
//        request.types = type;
//        request.requireExtension    = true
//        
//        mapSearch.aMapPOIPolygonSearch(request)
//        
//    }
    
    private func getPointsListFromPolygonString(_ polygons: String) -> [[CGPoint]] {
        let polygonList = polygons.components(separatedBy: ";")
        var resultPolygons = [[CGPoint]].init()
        for p in polygonList {
            resultPolygons.append(getPointsFromPolygonString(p))
        }
        return resultPolygons
    }
    
    private func getPointsFromPolygonString(_ polygon: String) -> [CGPoint] {
        let pointsXy = polygon.components(separatedBy: ",")
        let len = (pointsXy.count % 2 == 0) ? pointsXy.count : pointsXy.count - 1
        var result = Array<CGPoint>.init()
        var i = 0
        while (i < len) {
            result.append(CGPoint.init(x: Double(pointsXy[i])!, y: Double(pointsXy[i+1])!))
            i += 2
        }
        return result
    }
    
    private func drawPolygonList(polygonList: [[CGPoint]]) {
        
        var polygons = Array<MAPolygon>.init()
        for polygon in polygonList {
            var coord = Array<CLLocationCoordinate2D>.init()
            for p in polygon {
                coord.append(CLLocationCoordinate2D.init(latitude: Double(p.y), longitude: Double(p.x)))
            }
            let polygon = MAPolygon.init(coordinates: &coord, count: UInt(coord.count))
            
            polygons.append(polygon!)
        }
        
        self.addOverlays(overlays: polygons, edgePadding: UIEdgeInsetsMake(40, 40, 40, 40), animated: true)
        
//        self.mapView.addOverlays(polygons)
//        self.mapView.setVisibleMapRect(CommonUtility.mapRect(forOverlays: polygons), edgePadding: UIEdgeInsetsMake(40, 40, 40, 40), animated: true)
    }

// MapCustomDelegate callback
    func clearAnnotationsAndOverlays() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    func addAnnotation(annotation: MAPointAnnotation, animated: Bool) {
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: animated)
    }
    
    func addOverlays(overlays: Array<MAPolygon>, edgePadding insets:UIEdgeInsets, animated: Bool) {
        self.mapView.addOverlays(overlays)
        self.mapView.setVisibleMapRect(CommonUtility.mapRect(forOverlays: overlays), edgePadding: insets, animated: animated)
    }
    
    func setCenter(centerCoordinate: CLLocationCoordinate2D, animated: Bool) {
        self.mapView.setCenter(centerCoordinate, animated: animated)
    }
	
	// 引导去登录注册界面
	func popToLoginViewController()
	{
		let okaction = UIAlertAction(title: "登录", style: .default, handler: {
			// 跳转到维修主界面
			action in self.navigationController!.popToRootViewController(animated: true)
		})
		showAlert(title: "查看详情", message: "登录后可查看详细信息，是否去登录？", parentVC: self, okAction: okaction, cancel: true)
	}
	
	//
	// 键盘弹出时调整搜索结果tableview的高度
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(true, animated: true)
		
		// register for keyboard notifications
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	}
	
	// 调整搜索结果frame
	func keyboardWillShow(_ notif: NSNotification)
	{
		//keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
		if let userInfo = notif.userInfo
		{
			if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
			{
				print(keyboardSize.height)
				let searchbarTop = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
				self.searchResultTV.frame = CGRect.init(x: 0, y: searchbarTop + 44, width: self.view.frame.width, height: self.view.frame.height - searchbarTop - 44 - keyboardSize.height)
			}
			else
			{
				// no UIKeyboardFrameBeginUserInfoKey entry in userInfo
			}
		} else {
			// no userInfo dictionary in notification
		}
	}
}
