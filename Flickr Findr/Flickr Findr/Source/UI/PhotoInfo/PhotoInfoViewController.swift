//
//  PhotoInfoViewController.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/23/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController, ViewControllerInstanciator {

    // outlets (note: setting to private, swiftlint appreciates this)
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var IDLabel: UILabel!
    
    // constants
    private struct Constants {
        
        static let maxLengthForImageTitleOnVCTitle = 35
    }
    
    // properties
    private let viewModel: FlickrPhotoVM
    private let resultsHandler: UIImageView.ImageLoadResultsType?
    
    // lifecycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: FlickrPhotoVM, resultsHandler: @escaping UIImageView.ImageLoadResultsType) {
        
        // injected values are ideal on a number of levels, most importantly,
        // they reduce external dependencies as well as allowing the items to
        // be declared as constants since being injected in at init time
        // (which is not possible from storyboard support, need to assign
        // values after creation)
        self.viewModel = viewModel
        self.resultsHandler = resultsHandler
        super.init(nibName: PhotoInfoViewController.className, bundle: Bundle.main)
    }

    // view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fire up async photo load, non-thumbnail, if failed, most likely
        // would have failed at the icon, which removes the item ... if it
        // fails here, do default handling and show the error image.
        imageView.load(from: viewModel.model, isThumb: false, completionHandler: { (imageId, success) in

            if !success {

                self.resultsHandler?(imageId, success)
            }
        })

        // some file titles are very long, added separate space
        // to show on those.  most titles can fit in screen title
        // area.  for the exam, this was quick-n-dirty'ish, figured
        // better to show more of the title, and also allowed an
        // overlayed dithered field on the image.
        // also note: custom Back text on nav done via SB vs new button
        let model = viewModel.model
        
        if !model.title.isEmpty &&
            model.title.count < Constants.maxLengthForImageTitleOnVCTitle {
            
            // use title in vc title
            title = model.title
            titleLabel.isHidden = true
        }
        else {
            
            // use display area
            title = viewModel.title
            titleLabel.text = model.title
            titleLabel.isHidden = model.title.isEmpty
        }
        
        // more as developer sanity to check IDs on dup images ...
        IDLabel.text = model.id
    }
}
