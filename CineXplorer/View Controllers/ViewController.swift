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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else { return }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(query)&type=movie")!,
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
            
            
            let newMovies = finalResult.Search
            self.movies.append(contentsOf: newMovies)
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }).resume()
        
    }
}

extension ViewController: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
            cell.titleMovieLabel.text = self.movies[indexPath.row].title
            cell.yearMovieLabel.text = self.movies[indexPath.row].year
            let url = self.movies[indexPath.row].poster
            if let data = try? Data(contentsOf: URL(string: url)!) {
                cell.posterMovieImage.image = UIImage(data: data)
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
    
}
