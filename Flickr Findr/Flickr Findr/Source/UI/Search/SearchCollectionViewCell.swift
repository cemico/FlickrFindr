//
//  SearchCollectionViewCell.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/24/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    // outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // properties
    var resultsHandler: UIImageView.ImageLoadResultsType?

    var model: FlickrPhoto? {
        didSet {
            
            // models are set during cellForItem so should be fully
            // valid, safeguards on unattached outlets just in case
            guard let iv = imageView else { return }
            guard let imageModel = model else {
                
                iv.image = nil
                return
            }
            
            // load thumbnail - remove fail case
            iv.load(from: imageModel) { [weak self] (imageId: String, success: Bool) in

                // let caller decide how to handle failure
                self?.resultsHandler?(imageId, success)
            }
        }
    }
    
    // clean any residual
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
    }
}
