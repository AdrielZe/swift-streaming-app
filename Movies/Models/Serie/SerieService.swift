//
//  SerieService.swift
//  Movies
//
//  Created by ios-noite-2 on 11/07/24.
//

import Foundation

class SerieService {
    private let apiBaseUrl:String = "http://www.omdbapi.com/?apikey=3e2b1ec0&s="
    //static let url = URL(string:"http://www.omdbapi.com/?apikey=3e2b1ec0&type=series&s=")
    private let apiToken = "fad9f001"
    
    private var apiURL: String {
        apiBaseUrl// + apiToken
    }
    
    private let decoder = JSONDecoder()
    
    public func searchSeries(withTitle title:String, completion: @escaping (Serie, Error?) -> Void) {
        let url = URL(string:apiURL+title)
        guard let openedURL = url else { return }
        
        URLSession.shared.dataTask(with: openedURL) { data, response, error in
            
            guard let dataExists = data else { return }
            
            do{
                let result = try JSONDecoder().decode(Serie.self, from: dataExists)
                completion(result, nil)
        
            } catch{
                
            }
        }.resume()
    }
    
    func loadImageData(fromURL link: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data)
        }
        
        task.resume()
    }
    
    func searchSeries(withTitle title: String, completion: @escaping ([Serie]) -> Void) {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = apiURL + "&s=\(query)"

        guard let url = URL(string: endpoint) else {
            completion([])
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                    error == nil else {
                completion([])
                return
            }

            do {
                let serieResponse = try self.decoder.decode(SerieSearchResponse.self, from: data)
                let series = serieResponse.search
                completion(series)
            } catch {
                print("FETCH ALL SERIES ERROR: \(error)")
                completion([])
            }
        }

        task.resume()
    }
}
