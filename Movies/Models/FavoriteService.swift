//
//  FavoriteService.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import Foundation

class FavoriteService {
    
    // Singleton instance
    static let shared = FavoriteService()
    private init() {}
    
    // In memory data
    private var favoriteMovies: [Movie] = []
    private var favoriteSeries: [Serie] = []
    
    func listAll() -> [Movie] {
        favoriteMovies
    }
    

    func isFavorite(id: String, isMovie: Bool) -> Bool {
        if isMovie {
            return favoriteMovies.contains { movie in
                movie.id == id
            }
        } else {
            return favoriteSeries.contains { serie in
                serie.id == id
            }
        }
    }
    
    func isFavorite(id: String, isSerie: Bool) -> Bool {
        if isSerie {
            return favoriteSeries.contains { serie in
                serie.id == id
            }
        } else {
            return favoriteSeries.contains { serie in
                serie.id == id
            }
        }
    }

    func addMovie(_ movie: Movie) {
        favoriteMovies.append(movie)
    }
    
    func removeSerie(withId serieId: String) {
        favoriteSeries.removeAll { serie in
            serie.id == serieId
        }
    }
    
    func removeMovie(withId movieId: String) {
        favoriteMovies.removeAll { movie in
            movie.id == movieId
        }
    }
    
    func addSerie(_ serie: Serie) {
        favoriteSeries.append(serie)
    }
}
