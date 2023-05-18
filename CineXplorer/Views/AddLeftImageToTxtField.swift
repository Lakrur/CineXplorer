//
//  AddLeftImageToTxtField.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 16.05.2023.
//

import Foundation
import UIKit

func addLeftImageTo(textField: UITextField, andImage image: UIImage) {
    let leftImageView = UIImageView(image: image)
    leftImageView.contentMode = .scaleAspectFit
    let leftImageWidth = image.size.width
    let leftImageHeight = image.size.height
    let leftViewWidth = leftImageWidth + 20.0 
    let leftViewHeight = leftImageHeight
    let leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftViewWidth, height: leftViewHeight))
    leftView.addSubview(leftImageView)
    leftImageView.center = CGPoint(x: leftViewWidth / 2.0, y: leftViewHeight / 2.0)
    textField.leftView = leftView
    textField.leftViewMode = .always
}


