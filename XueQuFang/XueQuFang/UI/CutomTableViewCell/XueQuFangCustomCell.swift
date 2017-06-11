//
//  XueQuFangCustomCell.swift
//  XueQuFang
//
//  Created by en li on 2017/6/10.
//  Copyright © 2017年 xqf. All rights reserved.
//

import UIKit

class XueQuFangCustomCell: UITableViewCell {

	
	@IBOutlet weak var XueQuFangShortcut_img: UIImageView!
	@IBOutlet weak var XueQuFangAddress_L: UILabel!
	@IBOutlet weak var XueQuFangName_L: UILabel!
	
	private let imgSize = 60
	private let kmargin = 10
	private let textHeight = 25
	private let padding = 10
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.layoutUI()
    }
	
	func layoutUI()
	{
		self.XueQuFangShortcut_img.frame = CGRect.init(x: kmargin, y: kmargin, width: imgSize, height: imgSize)
		
		self.XueQuFangName_L.frame = CGRect.init(x: imgSize + kmargin * 2, y: kmargin, width: Int(self.frame.width) - imgSize - kmargin * 2, height: textHeight)
		
		self.XueQuFangAddress_L.frame = CGRect.init(x: imgSize + kmargin * 2, y: textHeight + kmargin + padding, width: Int(self.frame.width) - imgSize - kmargin * 2, height: textHeight)
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
