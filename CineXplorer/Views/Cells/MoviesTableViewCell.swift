//
//  MoviesTableViewCell.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 06.06.2023.
//

import Foundation
import UIKit

class MoviesTableViewCell: UITableViewCell, HasCellID {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var genreMovieName: UILabel!
    
}
