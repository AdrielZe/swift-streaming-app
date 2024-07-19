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
    @IBOutlet weak var seriePlotLabel: UILabel!
    
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
        loadSerieData()
    }
    
    private func loadSerieData() {
        guard serieId != nil else { return }
        
        serieService.searchSeries(withTitle: "stranger things") { serie, _ in
            
            self.serie = serie
            
            // Load movie image
            if let posterURL = serie.posterURL {
                self.serieService.loadImageData(fromURL: posterURL) { imageData in
                    self.updateSerieImage(withImageData: imageData)
                }
            }
            
            DispatchQueue.main.async {
                self.updateViewData()
            }
        }
    }
    
    private func updateViewData() {
        serieGenreLabel.text = serie?.genre
        serieCountryLabel.text = serie?.country
        serieLanguageLabel.text = serie?.language
        serieReleasedLabel.text = serie?.released
        seriePlotLabel.text = serie?.plot
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let serie = serie else { return }
        
        let isFavorite = favoriteService.isFavorite(id: serie.id, isMovie: false)
        self.serie?.isFavorite = isFavorite
        let favoriteIcon = isFavorite ? "heart.fill" : "heart"
        serieFavoriteButton.image = .init(systemName: favoriteIcon)
    }
    
    private func updateSerieImage(withImageData imageData: Data?) {
        guard let imageData = imageData else { return }
        
        DispatchQueue.main.async {
            let movieImage = UIImage(data: imageData)
            self.serieImageView.image = movieImage
        }
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let serie = serie else { return }
        
        if serie.isFavorite {
            // Remove movie from favorite list
            favoriteService.removeSerie(withId: serie.id)
        } else {
            // Add movie to favorite list
            favoriteService.addSerie(serie)
        }
        
        updateFavoriteButton()
    }
}
