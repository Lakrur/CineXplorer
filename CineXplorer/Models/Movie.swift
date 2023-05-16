//
//  MovieModel.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 14.05.2023.
//

import Foundation

struct MovieResult: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let overview: String
    let posterPath: String?
    let releaseDate, title: String
    let voteAverage: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}

