//
//  AnnotationCalloutView.swift
//  ZNGJ
//
//  Created by HuangBing on 1/21/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class AnnotationCalloutView : UIView {
    weak var delegate: CalloutViewDelegate!
    var searchType: SearchType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
//        Logger.logToConsole("annotation calloutview tapped !!!")
        
        // here we goto the detail view
        switch self.searchType! {
        case .xiaoqu:
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XiaoquDetailVC")
            if let newVC = vc as? XiaoquDetailViewController {
                delegate.dismissVC(animated: false, completion: nil)
                delegate.pushViewController(newVC, animated: true)
                
            }
            
        case .xuexiao:
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XuexiaoDetailVC")
            if let newVC = vc as? XuexiaoDetailViewController {
                delegate.dismissVC(animated: false, completion: nil)
                delegate.pushViewController(newVC, animated: true)
                
            }
        }
    }
}

public protocol CalloutViewDelegate : NSObjectProtocol {
    func presentVC(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismissVC(animated: Bool, completion: (() -> Void)?)
    func pushViewController(_ viewcontroller: UIViewController, animated: Bool)
    
}

