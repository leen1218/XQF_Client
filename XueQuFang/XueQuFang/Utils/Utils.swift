//
//  Utils.swift
//  XueQuFang
//
//  Created by en li on 2017/5/17.
//  Copyright © 2017年 xqf. All rights reserved.
//

import Foundation

import Foundation
import UIKit

func showAlert(title: String, message : String, parentVC: UIViewController, okAction: UIAlertAction?, cancel: Bool = false)
{
	let alertController = UIAlertController(title: title,
	                                        message: message,
	                                        preferredStyle: .alert)
	if cancel {
		let defaultCancelAction = UIAlertAction(title: "取消", style: .default, handler: {
			action in
		})
		alertController.addAction(defaultCancelAction)
	}
	if okAction == nil {
		let defaultOkAction = UIAlertAction(title: "确定", style: .default, handler: {
			action in
		})
		alertController.addAction(defaultOkAction)
	} else {
		alertController.addAction(okAction!)
	}
	parentVC.present(alertController, animated: true, completion: nil)
}
