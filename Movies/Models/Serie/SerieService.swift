//
//  SerieService.swift
//  Movies
//
//  Created by ios-noite-2 on 11/07/24.
//

import Foundation

class SeriesService {
    static let apiUrl:String = "http://www.omdbapi.com/?apikey=3e2b1ec0&type=series&s="
    //static let url = URL(string:"http://www.omdbapi.com/?apikey=3e2b1ec0&type=series&s=")
    public static func searchSeries(withTitle title:String, completion: @escaping (Series, Error?) -> Void) {
        let url = URL(string:apiUrl+title)
        guard let openedURL = url else { return }
        
        URLSession.shared.dataTask(with: openedURL) { data, response, error in
            
            guard let dataExists = data else { return }
            
            do{
                let result = try JSONDecoder().decode(Series.self, from: dataExists)
                completion(result, nil)
        
            } catch{
                
            }
        }.resume()
    }
}
