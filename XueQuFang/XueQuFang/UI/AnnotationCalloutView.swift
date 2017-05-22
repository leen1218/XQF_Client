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
    var searchResultItem: BaseItem?
    
    struct CalloutViewConstants {
        static let imageXMargin = 2
        static let imageYMargin = 2
        static let labelXMargin = 5
        static let imageWidth = 44
        static let imageHeight = 44
        static let labelWidth = 120
        static let labelHeight = 20
        static let titleFont: CGFloat = 14
        static let subtitleFont: CGFloat = 12
    }
    
    init(frame: CGRect, item: BaseItem) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.addGestureRecognizer(tap)
        self.searchResultItem = item
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initSubviews() {
        
        
        // provide the image in the left of popover
        let imageView = UIImageView.init(frame: CGRect.init(x: CalloutViewConstants.imageXMargin, y: CalloutViewConstants.imageYMargin, width: CalloutViewConstants.imageWidth, height: CalloutViewConstants.imageHeight))
        imageView.image = UIImage.init(imageLiteralResourceName: "zju.jpg")
        self.addSubview(imageView)
        
        // provide the title, which is the name of the school or the house
        let titleLabel = UILabel.init(frame: CGRect.init(x: CalloutViewConstants.imageXMargin + CalloutViewConstants.labelXMargin + CalloutViewConstants.imageWidth, y: CalloutViewConstants.imageYMargin, width: CalloutViewConstants.labelWidth, height: CalloutViewConstants.labelHeight))
        titleLabel.font = UIFont.boldSystemFont(ofSize: CalloutViewConstants.titleFont)
        titleLabel.textColor = UIColor.black
        titleLabel.text = self.searchResultItem?.name
        self.addSubview(titleLabel)
        
        // provide the subtitle, which is the detail address of the school or the house
        let subtitleLabel = UILabel.init(frame: CGRect.init(x: CalloutViewConstants.imageXMargin + CalloutViewConstants.labelXMargin + CalloutViewConstants.imageWidth, y: CalloutViewConstants.imageYMargin * 2 + CalloutViewConstants.labelHeight, width: CalloutViewConstants.labelWidth, height: CalloutViewConstants.labelHeight))
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: CalloutViewConstants.subtitleFont)
        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.text = self.searchResultItem?.detailAddress
        self.addSubview(subtitleLabel)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
//        Logger.logToConsole("annotation calloutview tapped !!!")
        
        // here we goto the detail view
        if self.searchResultItem?.type == "1" {
        
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XiaoquDetailVC")
            if let newVC = vc as? XiaoquDetailViewController {
                delegate.dismissVC(animated: false, completion: nil)
                delegate.pushViewController(newVC, animated: true)
                
            }
        } else {
            
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

