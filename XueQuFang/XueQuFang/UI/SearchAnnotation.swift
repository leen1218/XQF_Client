//
//  OrderAnnotation.swift
//  ZNGJ
//
//  Created by HuangBing on 1/17/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation
import MapKit

enum SearchType {
    case xiaoqu
    case xuexiao
}

class SearchAnnotation : MAPointAnnotation {
    var type: SearchType?
    var keyword: String?
    var detailAddress: String?
    
    init(_ coordinate: CLLocationCoordinate2D, keyword: String, address: String, type: SearchType) {
        super.init()
        self.coordinate = coordinate
        self.keyword = keyword
        self.detailAddress = address
        self.type = type
    }
}
