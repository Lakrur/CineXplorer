//
//  ViewController.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 13.05.2023.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var field: UITextField!
    
    var movies = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        field.delegate = self
        
        addLeftImageTo(textField: field, andImage: UIImage(named: "search")!)
        tableView.backgroundColor = .black
        
        fetchPopularMovies()
        
        field.layer.cornerRadius = 10.0
        field.layer.borderWidth = 2.0
        field.layer.cornerRadius = field.frame.size.height / 2.5
        field.clipsToBounds = true
        field.clearButtonMode = .whileEditing
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            
            guard let text = textField.text else {
                return true
            }
            
            if text.isEmpty {
                fetchPopularMovies()
            } else {
                searchMovies()
            }
            
            return true
    }
    
    
    func searchMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else { return }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)")!,
                                   completionHandler: { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("error")
            }
            
            guard let finalResult = result else { return }
            
            
            let newMovies = finalResult.results
            
            self.movies.append(contentsOf: newMovies)
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }).resume()
        
    }
    
    func fetchPopularMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, text.isEmpty else { return }

        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)")!,
                                   completionHandler: { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("error")
            }
            
            guard let finalResult = result else { return }
            
            
            let newMovies = finalResult.results
            
            self.movies.append(contentsOf: newMovies)
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }).resume()
    }
        
}

extension ViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No Results"
            emptyLabel.font = UIFont(name:"ArialRoundedMTBold", size: 18.0)
            emptyLabel.textColor = .gray
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        } else {
            self.tableView.backgroundView = nil
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        DispatchQueue.main.async {
            cell.titleMovieLabel.text = self.movies[indexPath.row].title
            cell.yearMovieLabel.text = self.movies[indexPath.row].releaseDate
            cell.overvwiewLabel.text = self.movies[indexPath.row].overview
            cell.vote.text = self.movies[indexPath.row].voteAverageString
            
            if let posterPath = self.movies[indexPath.row].posterPath,
               let url = URL(string: poster + posterPath) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.posterMovieImage.image = image
                        }
                    }
                }.resume()
            }
        }

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieTitle = movies[indexPath.row].title
        
        let encodedTitle = movieTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let searchURL = "https://www.imdb.com/find?q=\(encodedTitle)&s=tt"
        
        if let imdbSearchURL = URL(string: searchURL) {
            let vc = SFSafariViewController(url: imdbSearchURL)
            present(vc, animated: true)
        }
    }


    
}
