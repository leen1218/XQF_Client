//
//  CustomAnnotationView.swift
//  ZNGJ
//
//  Created by HuangBing on 1/23/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class CustomAnnotationView : MAPinAnnotationView, UIPopoverPresentationControllerDelegate {
//    var calloutView: AnnotationCalloutView!
    fileprivate static let calloutWidth = 200
    fileprivate static let calloutHeight = 70
    weak var delegate: CalloutViewDelegate!
    
    var searchAnnotation: SearchAnnotation?
    
    init(annotation: MAAnnotation, reuseIdentifier: String, delegate: CalloutViewDelegate) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        searchAnnotation = annotation as? SearchAnnotation
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAnnotationViewTap(sender:))))
        self.delegate = delegate
        // have to put the call here, otherwise no default popover
        // also need to add the delay here to make sure this happens after center movement by setCenter call
        delay(0.0) {
            self.showPopover()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func showPopover() {
        let calloutWidth = 170
        let calloutHeight = 48
        // we should present the callout view here with popover
        let calloutView = AnnotationCalloutView.init(frame: CGRect.init(x: 0, y: 0, width: calloutWidth, height: calloutHeight), item:self.searchAnnotation!.searchResultItem!)
        calloutView.delegate = self.delegate
        
        // Present the view controller using the popover style.
        let vc = UIViewController.init()
        vc.view.addSubview(calloutView)
        
        vc.preferredContentSize = CGSize.init(width: calloutWidth, height: calloutHeight)
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let presentationController = vc.popoverPresentationController
        presentationController?.permittedArrowDirections = .down
        presentationController?.sourceView = self
        presentationController?.sourceRect = self.bounds
        presentationController?.delegate = self
        
        self.delegate.presentVC(vc, animated: true, completion: nil)
    }
    
    func handleAnnotationViewTap(sender: UITapGestureRecognizer) {
        showPopover()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        if self.isSelected == selected {
//            return
//        }
//        if selected {
//            if self.calloutView == nil {
//                self.calloutView = AnnotationCalloutView.init(frame: CGRect.init(x: 0, y: 0, width: CustomAnnotationView.calloutWidth, height: CustomAnnotationView.calloutHeight))
//                self.calloutView.center = CGPoint.init(x: self.bounds.size.width / 2.0 + self.calloutOffset.x, y: -self.calloutView.bounds.size.height / 2.0 + self.calloutOffset.y)
//                self.calloutView.setOrderId(self.orderIds)
//                self.calloutView.isUserInteractionEnabled = true
//            }
//            
//            self.addSubview(self.calloutView)
//        } else {
//            self.calloutView.removeFromSuperview()
//            
//            // navigate to detail
//            var topVC = UIApplication.shared.keyWindow?.rootViewController
//            while((topVC!.presentedViewController) != nil) {
//                topVC = topVC!.presentedViewController
//            }
//            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XiaoQuXueXiaoDetailInfoVC")
//            if let newVC = vc as? UIViewController {
////                newVC.order = UserModel.SharedUserModel().orderManager.getUnreservedOrdersFromIds(self.orderIds)[0]                
//                self.delegate.pushViewController(newVC, animated: true)
//            }
//            
//        }
//        super.setSelected(selected, animated: animated)
//    }

}
