//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Geovana Contine on 26/03/24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let apiService = MovieService()
    
    func setup(imageData : Data?, title : String) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        
        // Clean data
        imageView.image = nil
        titleLabel.text = nil
        
        self.updateCell(withImageData: imageData, orTitle: title)

    }
    
//    func setup(movie: Movie) {
//        imageView.layer.masksToBounds = true
//        imageView.layer.cornerRadius = 8
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.black.cgColor
//
//        // Clean data
//        imageView.image = nil
//        titleLabel.text = nil
//
//        // Load movie poster from URL
//        if let posterURL = movie.posterURL {
//            apiService.loadImageData(fromURL: posterURL) { imageData in
//                //self.updateCell(withImageData: imageData, orTitle: movie.title)
//            }
//        }
//    }
    
    private func updateCell(withImageData imageData: Data?, orTitle title: String) {
        DispatchQueue.main.async {
            if let imageData = imageData {
                // Show movie image
                let movieImage = UIImage(data: imageData)
                self.imageView.image = movieImage
            } else {
                // Show movie title if poster is not available
                self.titleLabel.text = title
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
}
