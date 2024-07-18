//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class SeriesDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var serieFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var serieTitleLabel: UILabel!
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieGenreLabel: UILabel!
    @IBOutlet weak var serieCountryLabel: UILabel!
    @IBOutlet weak var serieReleasedLabel: UILabel!
    @IBOutlet weak var serieLanguageLabel: UILabel!
    @IBOutlet weak var mseriePlotLabel: UILabel!
    
    // Services
    var serieService = SerieService()
    var favoriteService = FavoriteService.shared
    
    // Data
    var serieId: String?
    var serieTitle: String?
    private var serie: Serie?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serieTitleLabel.text = serieTitle
        loadserieData()
    }
    
    private func loadSerieData() {
        guard let serieId = serieId else { return }
        
        serieService.searchMovie(withId: serieId) { serie in
            
            self.serie = serie
            
            // Load movie image
            if let posterURL = movie?.posterURL {
                self.movieService.loadImageData(fromURL: posterURL) { imageData in
                    self.updateMovieImage(withImageData: imageData)
                }
            }
            
            DispatchQueue.main.async {
                self.updateViewData()
            }
        }
    }
    
    private func updateViewData() {
        movieGenreLabel.text = movie?.genre
        movieCountryLabel.text = movie?.country
        movieLanguageLabel.text = movie?.language
        movieReleasedLabel.text = movie?.released
        moviePlotLabel.text = movie?.plot
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let movie = movie else { return }
        
        let isFavorite = favoriteService.isFavorite(movieId: movie.id)
        self.movie?.isFavorite = isFavorite
        let favoriteIcon = isFavorite ? "heart.fill" : "heart"
        movieFavoriteButton.image = .init(systemName: favoriteIcon)
    }
    
    private func updateMovieImage(withImageData imageData: Data?) {
        guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
            let movieImage = UIImage(data: imageData)
            self.movieImageView.image = movieImage
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let movie = movie else { return }
        
        if movie.isFavorite {
            // Remove movie from favorite list
            favoriteService.removeMovie(withId: movie.id)
        } else {
            // Add movie to favorite list
            favoriteService.addMovie(movie)
        }
        
        updateFavoriteButton()
    }
}
