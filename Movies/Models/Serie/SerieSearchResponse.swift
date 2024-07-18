//
//  SerieSearchResponse.swift
//  Movies
//
//  Created by ios-noite-09 on 17/07/24.
//

import Foundation

struct SerieSearchResponse: Decodable {
    let search: [Serie]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
