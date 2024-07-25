//
//  SerieService.swift
//  Movies
//
//  Created by ios-noite-2 on 11/07/24.
//

import Foundation

struct SerieService {
    
    private let apiBaseURL = "https://www.omdbapi.com/?apikey="
    private let apiToken = "fad9f001"
    private let filter = "&type=series&"
    
    private var apiURL: String {
        apiBaseURL + apiToken + filter
    }
    
    private let decoder = JSONDecoder()

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
                let serieResponse = try decoder.decode(SerieSearchResponse.self, from: data)
                let series = serieResponse.search
                completion(series)
            } catch {
                print("FETCH ALL SERIES ERROR: \(error)")
                completion([])
            }
        }
        
        task.resume()
    }

    func searchSerie(withId serieId: String, completion: @escaping (Serie?) -> Void) {
        let query = serieId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = apiURL + "&i=\(query)"
        
        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let serie = try decoder.decode(Serie.self, from: data)
                completion(serie)
            } catch {
                print("FETCH SERIE ERROR: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
//    public func searchSeries(withTitle title:String, completion: @escaping (Serie, Error?) -> Void) {
//        let url = URL(string:apiURL+title)
//        guard let openedURL = url else { return }
//
//        URLSession.shared.dataTask(with: openedURL) { data, response, error in
//
//            guard let dataExists = data else { return }
//
//            do{
//                let result = try JSONDecoder().decode(Serie.self, from: dataExists)
//                completion(result, nil)
//
//            } catch{
//
//            }
//        }.resume()
//    }
//
//
//
//
//    func searchSerie(withId serieId: String, completion: @escaping (Serie?) -> Void) {
//        let query = serieId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let endpoint = apiURL + "&s=\(query)"
//
//        guard let url = URL(string: endpoint) else {
//            completion(nil)
//            return
//        }
//
//        let request = URLRequest(url: url)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//
//                guard let data = data else {
//                    completion(nil)
//                    return
//            }
//
//            do {
//                let serieResponse = try self.decoder.decode(SerieSearchResponse.self, from: data)
//                let series = serieResponse.search
//
//                let serie = try decoder.decode(Serie.self, from: data)
//                completion(series)
//            } catch {
//                print("FETCH ALL SERIES ERROR: \(error)")
//                completion([])
//            }
//        }
//
//        task.resume()
//    }
    
    
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
}
