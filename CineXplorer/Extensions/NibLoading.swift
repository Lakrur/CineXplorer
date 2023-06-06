//
//  NibLoading.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 06.06.2023.
//

import UIKit

protocol NibLoading {
    
    static func loadNib() -> UINib
}

extension NibLoading where Self: AnyObject {
    
    static func loadNib() -> UINib {
        let nibName = String(describing: self)
        return UINib(nibName: nibName, bundle: Bundle(for: self as AnyClass))
    }
}
