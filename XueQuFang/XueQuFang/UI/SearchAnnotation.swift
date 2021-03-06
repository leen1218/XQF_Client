//
//  OrderAnnotation.swift
//  ZNGJ
//
//  Created by HuangBing on 1/17/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation
import MapKit


class SearchAnnotation : MAPointAnnotation {
    var baseItem: BaseItem?
    
    init(_ coordinate: CLLocationCoordinate2D, item: BaseItem) {
        super.init()
		self.coordinate = coordinate
        self.baseItem = item
    }
}
