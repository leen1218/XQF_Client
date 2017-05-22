//
//  MapCustomDelegate.swift
//  XueQuFang
//
//  Created by HuangBing on 5/17/17.
//  Copyright © 2017 xqf. All rights reserved.
//

import Foundation

class MapCustomDelegate : NSObject, MAMapViewDelegate, AMapSearchDelegate, CalloutViewDelegate {
    
    init(delegateVC: SearchMainVC) {
        super.init()
        self.delegate = delegateVC
    }
    
    weak var delegate:SearchMainVC!
    
    //MARK: - MAMapViewDelegate
    
//    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
//        // print("name: \(view.annotation.title)")
//    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! CustomAnnotationView?
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier, delegate: self)
            }
            
            annotationView!.canShowCallout = false
//            annotationView!.setOrderId([1,2], self)
//            annotationView!.isDraggable = false
//            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
//            if let newAnnotation = annotation as? OrderAnnotation {
//                if let newView = annotationView as CustomAnnotationView! {
//                    annotationView!.setOrderId([1,1], self)
//                }
//            }
            
            return annotationView!
        }
        
        return nil
        
        
        

        
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
//            
//            if annotationView == nil {
//                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//            }
//            
//            annotationView!.canShowCallout = true
//            annotationView!.isDraggable = false
//            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
//            
//            return annotationView!
//        }
//        
//        return nil
        
        
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if (overlay.isKind(of: MAPolygon.classForCoder())) {
            let polygonRenderer = MAPolygonRenderer.init(overlay: overlay)
//            polygonRenderer?.fillColor   = UIColor.init(red: 0.29412, green: 0.6, blue: 0.98824, alpha: 0.35)
            polygonRenderer?.fillColor   = UIColor.init(red: 219/255.0, green: 81/255.0, blue: 73/255.0, alpha: 0.4)
            return polygonRenderer
        }
        return nil
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
        
        if let geocode = response.geocodes.first {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(geocode.location.latitude), longitude: CLLocationDegrees(geocode.location.longitude))
            var keyword = geocode.formattedAddress
            var detailAddress = geocode.location.description
            if let newRequest = request as? CustomGeocodeSearchRequest {
                // here the type is xuexiao because we use this search instead of search polygon which has some problems.
                keyword = newRequest.address
                detailAddress = newRequest.detailAddress!
            }
            let anno = SearchAnnotation.init(coordinate, keyword: keyword!, address: detailAddress, type: .xuexiao)
            delegate.addAnnotation(annotation: anno, animated: true)
            
//            mapView.addAnnotation(anno)
//            mapView.selectAnnotation(anno, animated: false)
        }
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if (request.isKind(of: AMapPOIKeywordsSearchRequest.classForCoder())) {
            
            if response.count == 0 {
                return
            }
            
            if let aPOI = response.pois.first {
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
//                var type = SearchType.xuexiao
//                if (request.isKind(of: AMapPOIKeywordsSearchRequest.classForCoder())) {
//                    // in case of polygon search, don't have to move the center
//                    delegate.setCenter(centerCoordinate: coordinate, animated: false)
//                    type = SearchType.xiaoqu
//                }
                

                // in case of polygon search, don't have to move the center
                delegate.setCenter(centerCoordinate: coordinate, animated: false)

                var keyword = aPOI.name
                var detailAddress = aPOI.address
                if let newRequest = request as? CustomPOIKeywordsSearchRequest {
                    // here the type is xuexiao because we use this search instead of search polygon which has some problems.
                    keyword = newRequest.keywords
                    detailAddress = newRequest.detailAddress!
                }
                let anno = SearchAnnotation.init(coordinate, keyword: keyword!, address: detailAddress!, type: .xiaoqu)
                delegate.addAnnotation(annotation: anno, animated: true)
                
//                mapView.addAnnotation(anno)
//                mapView.selectAnnotation(anno, animated: false)
            }
        }
        
    }
    
    // MARK: CalloutViewDelegate
    func presentVC(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.delegate.present(viewControllerToPresent, animated: animated, completion: completion)
    }
    
    func dismissVC(animated: Bool, completion: (() -> Void)?) {
        self.delegate.dismiss(animated: animated, completion: completion)
    }
    
    func pushViewController(_ viewcontroller: UIViewController, animated: Bool) {
        self.delegate.navigationController?.pushViewController(viewcontroller, animated: animated)
    }
    
}
