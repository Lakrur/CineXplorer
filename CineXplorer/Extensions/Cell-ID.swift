//
//  Cell-ID.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 03.06.2023.
//

import Foundation

protocol HasCellID {
    static var reusableIdentifier: String { get }
}

extension HasCellID {
    static var reusableIdentifier: String {
        String(describing: self)
    }
}
