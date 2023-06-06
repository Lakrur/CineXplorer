//
//  MoviesTableViewCell.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 06.06.2023.
//

import UIKit


class MoviesTableViewCell: UITableViewCell, HasCellID {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var genreMovieName: UILabel!
    
    var movies = [Movie]()
    var genreMovies = [Genre]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    
    func fetchedAllGenres() {
        for genre in Genre.allCases {
            genreFilms(genre: genre)
        }
    }

    func genreFilms(genre: Genre) {
        
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&with_genres=\(genre.rawValue)")!) { [weak self] data, response, error in
            
            guard let data = data, error == nil else { return }
            
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            } catch {
                print("error")
            }
            
            guard let finalResult = result else { return }
            
            
            let newMovies = finalResult.results
            
            self?.genreMovies.append(genre)
            
            self?.movies.append(contentsOf: newMovies)
            
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
            
            
        }.resume()
        
    }
}



extension MoviesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreMoviesCell.reusableIdentifier, for: indexPath) as! GenreMoviesCell

        cell.background.layer.cornerRadius = 15
        
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

extension MoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 200
        let height: CGFloat = 250
        return CGSize(width: width, height: height)
    }
    
}

