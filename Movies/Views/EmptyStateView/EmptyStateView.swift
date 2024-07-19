//
//  EmptyStateView.swift
//  Movies
//
//  Created by ios-noite-05 on 18/07/24.
//

import UIKit

class EmptyStateView: UIView {
    static let identifier = "EmptyStateView"
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {

        let nib = UINib(nibName: EmptyStateView.identifier, bundle: nil)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as?
                            UIView else {fatalError("Unable to convert nib")}

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)

    }
        
    func configureImageAndText(image : UIImage, text : String){
        label.text = text
        image.image = image
    }

}
