//
//  MovieListViewController.swift/Users/ios-noite-09/Desktop/swift-streaming-app/Movies/Models/Movie/MovieSearchResponse.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class SeriesListViewController: UIViewController {

    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Services
    var serieService = SerieService()
    
    // Search
    
    private let searchController = UISearchController()
    private let defaultSearchName = "The boys"
    private var series: [Serie] = []
    private let segueIdentifier = "showSerieDetailVC"
    
    // Collection item parameters
    private let itemsPerRow = 2.0
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadSeries(withTitle: defaultSearchName)
    }
    
    private func setupViewController() {
        setupSearchController()
        setupCollectionView()
    }
    
    private func loadSeries(withTitle serieTitle: String) {
        serieService.searchSeries(withTitle: serieTitle) { series in
            DispatchQueue.main.async {
                self.series = series
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Pesquisar"
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let serieDetailVC = segue.destination as? SeriesDetailViewController,
              let serie = sender as? Serie else {
            return
        }
        
        serieDetailVC.serieId = serie.id
        serieDetailVC.serieTitle = serie.title
    }
}

// MARK: - UICollectionViewDataSource

extension SeriesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        series.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SerieCollectionViewCell.identifier, for: indexPath) as? SerieCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//
//        let serie = series[indexPath.row]
//        cell.setup(serie: serie)
//        return cell
//   }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CollectionViewCell else { return }
        
        let serie = series[indexPath.row]
        
        if let posterURL = serie.posterURL {
            serieService.loadImageData(fromURL: posterURL) { imageData in
                //self.updateCell(withImageData: imageData, orTitle: movie.title)
                DispatchQueue.main.async {
                    if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                        cell.setup(imageData: imageData, title: serie.title)
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SeriesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionWidth = collectionView.frame.size.width - marginSize
        let availableWidth = collectionWidth - (spaceBetweenItems * itemsPerRow)
        
        let itemWidth = availableWidth / itemsPerRow
        let itemHeight = itemWidth * itemAspectRatio
        
        return .init(width: itemWidth, height: itemHeight)
    }
}

// MARK: - UICollectionViewDelegate

extension SeriesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSerie = series[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedSerie)
    }
}

// MARK: - UISearchResultsUpdating

extension SeriesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            loadSeries(withTitle: defaultSearchName)
        } else {
            loadSeries(withTitle: searchText)
        }
        
        collectionView.reloadData()
    }
}
