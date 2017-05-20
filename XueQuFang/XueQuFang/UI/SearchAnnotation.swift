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
    
    init(_ coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: SearchType) {
        super.init()
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
}
