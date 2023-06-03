//
//  MoviesViewController.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 03.06.2023.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            dramaFilms()
        
    }
    
    func dramaFilms() {
        
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&with_genres=18")!) { [weak self] data, response, error in
            
            guard let data = data, error == nil else { return }
            
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            } catch {
                print("error")
            }
            
            guard let finalResult = result else { return }
            
            
            let newMovies = finalResult.results
            
            self?.movies.append(contentsOf: newMovies)
            
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
            
        }.resume()
        
    }
}


extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    

        return 1
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.reusableIdentifier, for: indexPath) as! MoviesTableViewCell

        cell.collectionView.register(GenreMoviesCell.loadNib(), forCellWithReuseIdentifier: GenreMoviesCell.reusableIdentifier)
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        cell.collectionView.collectionViewLayout = layout

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let cellHeight: CGFloat = 260
            return cellHeight
        }

    
    
}


extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreMoviesCell.reusableIdentifier, for: indexPath) as! GenreMoviesCell

        DispatchQueue.main.async {
            cell.nameFilm.text = self.movies[indexPath.row].title
            cell.rateFilm.text = self.movies[indexPath.row].voteAverageString

            if let posterPath = self.movies[indexPath.row].posterPath,
               let url = URL(string: poster + posterPath) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }

                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.posterFilm.image = image
                        }
                    }
                }.resume()
            }
        }

        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 200
        let height: CGFloat = 250
        return CGSize(width: width, height: height)
    }
    
}

