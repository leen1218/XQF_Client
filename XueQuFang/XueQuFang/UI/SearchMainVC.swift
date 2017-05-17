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
	
	// Search Bar
	var searchbar:UISearchBar!

	// Search Result TableView
	var searchResultTV:UITableView!
	let searchResultItemHeight:Int = 44
	let searchResultItemMaxCount = 10
	
	var searchRecords = [SearchResultItem]()
	var searchResults = [SearchResultItem]()
	var useSearchRecord:Bool!
    
    var mapView: MAMapView!
    var mapSearch: AMapSearchAPI!
	
	// Request handler
	var schoolHandler: SchoolHandler!
	var houseHandler: HouseHandler!
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView!)
        
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
        mapSearch.delegate = self
    }
	
	func setupUI()
	{
        // 搜索框
		let searchbarTop = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
		self.searchbar = UISearchBar.init(frame: CGRect.init(x: 0, y: searchbarTop, width: self.view.bounds.size.width, height: 44))
		self.searchbar.delegate = self
		self.view.addSubview(self.searchbar)
        
        // 地图
        initMapView()
        initSearch()
		
		// 搜索结果的TableView
		self.searchResultTV = UITableView.init()
		self.searchResultTV.translatesAutoresizingMaskIntoConstraints = false
		self.searchResultTV.delegate = self
		self.searchResultTV.dataSource = self
		self.searchResultTV.tableFooterView?.frame = CGRect.init()
		self.searchResultTV.isHidden = true // Invisible at initial
		self.view.addSubview(self.searchResultTV)
		
		//TODO: 根据结果数据计算frame
		// Left
		self.searchResultTV.translatesAutoresizingMaskIntoConstraints = false
		self.view.addConstraint(NSLayoutConstraint.init(item: self.searchResultTV, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0.0))
		// Top
		self.view.addConstraint(NSLayoutConstraint.init(item: self.searchResultTV, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.searchbar, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
		// Bottom
		self.view.addConstraint(NSLayoutConstraint.init(item: self.searchResultTV, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0))
		// Width
		self.view.addConstraint(NSLayoutConstraint.init(item: self.searchResultTV, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0))
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
			self.searchRecords.append(SearchResultItem.init(item_name: searchRecord["name"] as! String, item_id: searchRecord["id"] as! Int, item_isXueXiao: searchRecord["isXueXiao"] as! Bool))
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
		let params:Dictionary<String, String> = ["id":String(xiaoxueId)]
		request.params = params
		self.schoolHandler = SchoolHandler(delegateVC: self)
		request.handler = self.schoolHandler
		request.start()
	}
	
	//小区信息请求
	func xiaoquInfo(xiaoquId:Int)
	{
		let request:XQFRequest = XQFRequestManager.shared().createRequest(ENUM_REQUEST_HOUSE)
		let params:Dictionary<String, String> = ["id":String(xiaoquId)]
		request.params = params
		self.houseHandler = HouseHandler(delegateVC: self)
		request.handler = self.houseHandler
		request.start()
	}
	
	//MARK: SearchBar Delegate
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.searchbar.showsCancelButton = true
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
		self.searchbar.showsCancelButton = false
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.searchbar.resignFirstResponder()
		self.searchbar.showsCancelButton = false
		self.searchbar.text = ""
		self.searchResultTV.isHidden = true
	}
	
	func updateSearchRecords(searchItem:SearchResultItem)
	{
		for i in 0 ..< self.searchRecords.count {
			if self.searchRecords[i].name == searchItem.name
			{
				if i > 0 {
					swap(&self.searchRecords[0], &self.searchRecords[i])
				}
				return
			}
		}
		self.searchRecords.insert(SearchResultItem.init(item:searchItem), at: 0)
		if (self.searchRecords.count > 10) {
			self.searchRecords.removeLast()
		}
		// Save searchRecords into UserDefault
		var searchRecordSaved = [Dictionary<String, Any>]()
		for i in 0 ..< self.searchRecords.count
		{
			var searchRecord = Dictionary<String, Any>()
			searchRecord["name"] = self.searchRecords[i].name
			searchRecord["id"] = self.searchRecords[i].id
			searchRecord["isXueXiao"] = self.searchRecords[i].isXueXiao
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
		if selectedItem.isXueXiao  // Search XueXiao
		{
			self.xiaoxueInfo(xiaoxueId: selectedItem.id)
		}
		else  // Search XiaoQu
		{
			self.xiaoquInfo(xiaoquId: selectedItem.id)
		}
		// 添加search records
		self.updateSearchRecords(searchItem: selectedItem)
		
		// 更新UI
		self.searchbar.resignFirstResponder()
		self.searchbar.showsCancelButton = false
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
					self.searchResults.append(SearchResultItem.init(item_name: searchResult["name"] as! String, item_id: searchResult["id"] as! Int, item_isXueXiao: searchResult["isXueXiao"] as! String == "0" ? false : true))
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
    func searchXiaoQu(name xiaoQu: String, inCity city: String, withType type: String) {
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = xiaoQu
        request.requireExtension = true
        request.types = type
        request.city = city
        
        request.cityLimit = true
        request.requireSubPOIs = true
        mapSearch.aMapPOIKeywordsSearch(request)
    }
    
    func searchDetailAddress(address: String) {
        let request = AMapGeocodeSearchRequest()
        request.address = address
        mapSearch.aMapGeocodeSearch(request)
    }
    
    func searchXueXiao(name xueXiao: String, withType type: String, withPolygon polygonPoints: Array<CGPoint>) {
        
        
        // search with polygon
        let request = AMapPOIPolygonSearchRequest()
        var points = Array<AMapGeoPoint>.init()
        for p in polygonPoints {
            points.append(AMapGeoPoint.location(withLatitude: p.y, longitude: p.x))
        }
        request.polygon = AMapGeoPolygon.init(points: points)
        
        request.keywords            = xueXiao
        request.types = type;
        request.requireExtension    = true
        
        mapSearch.aMapPOIPolygonSearch(request)
        
    }
    
    func getPointsFromPolygonString(_ polygon: String) -> [CGPoint] {
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
    
    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        // print("name: \(view.annotation.title)")
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.isDraggable = false
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            return annotationView!
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if (overlay.isKind(of: MAPolygon.classForCoder())) {
            let polygonRenderer = MAPolygonRenderer.init(overlay: overlay)
            polygonRenderer?.lineWidth = 4.0
            polygonRenderer?.strokeColor = UIColor.green
            polygonRenderer?.fillColor   = UIColor.red
            return polygonRenderer
        }
        return nil
    }
    
    func drawPolygon(polygonPoints: Array<CGPoint>) {
        
        self.mapView.removeOverlays(self.mapView.overlays)
        
        var coord = Array<CLLocationCoordinate2D>.init()
        for p in polygonPoints {
            coord.append(CLLocationCoordinate2D.init(latitude: Double(p.y), longitude: Double(p.x)))
        }
        let polygon = MAPolygon.init(coordinates: &coord, count: UInt(coord.count))
        
        var polygons = Array<MAPolygon>.init()
        polygons.append(polygon!)
        
        self.mapView.addOverlays(polygons)
        self.mapView.setVisibleMapRect(CommonUtility.mapRect(forOverlays: polygons), animated: true)
    }

    
    //MARK: - AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
//        let nsErr:NSError? = error as NSError
//        NSLog("Error:\(error) - \(ErrorInfoUtility.errorDescription(withCode: (nsErr?.code)!))")
    }
    
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        
        if response.geocodes == nil {
            return
        }
        
        mapView.removeAnnotations(mapView.annotations)
        
        if let geocode = response.geocodes.first {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(geocode.location.latitude), longitude: CLLocationDegrees(geocode.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = geocode.formattedAddress
            anno.subtitle = geocode.location.description
            
            mapView.addAnnotation(anno)
            mapView.selectAnnotation(anno, animated: false)
        }
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if (request.isKind(of: AMapPOIKeywordsSearchRequest.classForCoder())) {
            mapView.removeAnnotations(mapView.annotations)
            
            if response.count == 0 {
                return
            }
            
            if let aPOI = response.pois.first {
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
                let anno = MAPointAnnotation()
                anno.coordinate = coordinate
                anno.title = aPOI.name
                anno.subtitle = aPOI.address
                
                mapView.addAnnotation(anno)
                mapView.selectAnnotation(anno, animated: false)
            }
        } else if (request.isKind(of: AMapPOIPolygonSearchRequest.classForCoder())) {
            mapView.removeAnnotations(mapView.annotations)
            
            if response.count == 0 {
                return
            }
            
            if let aPOI = response.pois.first {
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
                let anno = MAPointAnnotation()
                anno.coordinate = coordinate
                anno.title = aPOI.name
                anno.subtitle = aPOI.address
                
                mapView.addAnnotation(anno)
                mapView.selectAnnotation(anno, animated: false)
            }
        }
        
    }
    
}
