//
//  SearchTableViewCell.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 16.05.2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    @IBOutlet var titleMovieLabel: UILabel!
    @IBOutlet var yearMovieLabel: UILabel!
    @IBOutlet var posterMovieImage: UIImageView!
    @IBOutlet var overvwiewLabel: UILabel!
    @IBOutlet var vote: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    
}
