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
    var model: FlickrPhoto? {
        didSet {
            
            // models are set during cellForItem so should be fully
            // valid, safeguards on unattached outlets just in case
            guard let iv = imageView else { return }
            guard let imageModel = model else {
                
                iv.image = nil
                return
            }
            
            // load thumbnail
            iv.load(from: imageModel)
        }
    }
    
    // clean any residual
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
    }
}
