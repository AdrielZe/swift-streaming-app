//
//  MovieListViewController.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class MovieListViewController: UIViewController {

    // Outlets
    @IBOutlet weak var emptyMoviesNotFound: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Services
    var movieService = MovieService()
    
    // Search
    private let searchController = UISearchController()
    private let defaultSearchName = "Harry Potter"
    private var movies: [Movie] = []
    private let segueIdentifier = "showMovieDetailVC"
    
    // Collection item parameters
    private let itemsPerRow = 2.0
    private let spaceBetweenItems = 6.0
    private let itemAspectRatio = 1.5
    private let marginSize = 32.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        loadMovies(withTitle: defaultSearchName)
    }
    
    private func setupViewController() {
        setupSearchController()
        setupCollectionView()
    }
    
    private func loadMovies(withTitle movieTitle: String) {
        movieService.searchMovies(withTitle: movieTitle) { movies in
            DispatchQueue.main.async {
                self.movies = movies
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
        guard let movieDetailVC = segue.destination as? MovieDetailViewController,
              let movie = sender as? Movie else {
            return
        }
        
        movieDetailVC.movieId = movie.id
        movieDetailVC.movieTitle = movie.title
    }
}

// MARK: - UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CollectionViewCell else { return }
        
        let movie = movies[indexPath.row]
        
        if let posterURL = movie.posterURL {
            movieService.loadImageData(fromURL: posterURL) { imageData in
                //self.updateCell(withImageData: imageData, orTitle: movie.title)
                DispatchQueue.main.async {
                    if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                        cell.setup(imageData: imageData, title: movie.title)
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
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

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: selectedMovie)
    }
}

// MARK: - UISearchResultsUpdating

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if searchText.isEmpty {
            loadMovies(withTitle: defaultSearchName)
        } else {
            loadMovies(withTitle: searchText)
        }
        
        collectionView.reloadData()
    }
}
