//
//  GenreMoviesCell.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 03.06.2023.
//

import UIKit

final class GenreMoviesCell: UICollectionViewCell, HasCellID, NibLoading {
    
    
    @IBOutlet var posterFilm: UIImageView!
    @IBOutlet var nameFilm: UILabel!
    @IBOutlet var rateFilm: UILabel!
    @IBOutlet var background: UIView!
    

}
