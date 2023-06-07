//
//  MoviesViewController.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 03.06.2023.
//

import UIKit
import SafariServices

class MoviesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var genres: [Genre] = [] 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genres = Genre.allCases
        
        
        tableView.reloadData()
    }
    
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.reusableIdentifier, for: indexPath) as! MoviesTableViewCell
            
            cell.collectionView.register(GenreMoviesCell.loadNib(), forCellWithReuseIdentifier: GenreMoviesCell.reusableIdentifier)
        
            cell.moviesViewController = self
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            cell.collectionView.collectionViewLayout = layout
            
            let genre = genres[indexPath.row]
            cell.genreMovieName.text = genre.stringValue
            cell.genreFilms(genre: genre)
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 310
        return cellHeight
    }
}

