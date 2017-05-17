//
//  MapCustomDelegate.swift
//  XueQuFang
//
//  Created by HuangBing on 5/17/17.
//  Copyright © 2017 xqf. All rights reserved.
//

import Foundation

class MapCustomDelegate : NSObject, MAMapViewDelegate, AMapSearchDelegate {
    
    init(delegateVC: SearchMainVC) {
        super.init()
        self.delegate = delegateVC
    }
    
    var delegate:SearchMainVC!
    
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
            polygonRenderer?.fillColor   = UIColor.init(red: 0.29412, green: 0.6, blue: 0.98824, alpha: 0.35)
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
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = geocode.formattedAddress
            anno.subtitle = geocode.location.description
            
            delegate.addAnnotation(annotation: anno, animated: false)
            
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
                let anno = MAPointAnnotation()
                anno.coordinate = coordinate
                anno.title = aPOI.name
                anno.subtitle = aPOI.address
                
                delegate.addAnnotation(annotation: anno, animated: false)
                
//                mapView.addAnnotation(anno)
//                mapView.selectAnnotation(anno, animated: false)
            }
        } else if (request.isKind(of: AMapPOIPolygonSearchRequest.classForCoder())) {
            
            if response.count == 0 {
                return
            }
            
            if let aPOI = response.pois.first {
                let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
                let anno = MAPointAnnotation()
                anno.coordinate = coordinate
                anno.title = aPOI.name
                anno.subtitle = aPOI.address
                
                delegate.addAnnotation(annotation: anno, animated: false)
                
//                mapView.addAnnotation(anno)
//                mapView.selectAnnotation(anno, animated: false)
            }
        }
        
    }
    
}
