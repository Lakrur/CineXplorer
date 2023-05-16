//
//  AddLeftImageToTxtField.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 16.05.2023.
//

import Foundation
import UIKit

func addLeftImageTo(textField: UITextField, andImage image: UIImage) {
    let leftImageView = UIImageView(frame: CGRect(x: 110.0, y: 0.0, width: image.size.width, height: image.size.height))
    leftImageView.image = image
    textField.leftView = leftImageView
    textField.leftViewMode = .always
}
