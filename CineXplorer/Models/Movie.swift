//
//  MovieModel.swift
//  CineXplorer
//
//  Created by Yehor Krupiei on 14.05.2023.
//

import Foundation

struct MovieResult: Codable {
    let Search: [Movie]
}

struct Movie: Codable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title", year = "Year", imdbID, type = "Type", poster = "Poster"
    }
}

