//
//  FlickrRecent.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// model class for: https://www.flickr.com/services/api/flickr.photos.getRecent.html
struct FlickrRecent: FlickrPhotosDecodale {

    // protocol conformance

    // results related
    private(set) var photos: FlickrPhotos

    // success related
    private(set) var stat: String
}

// custom output
extension FlickrRecent: CustomStringConvertible {

    var description: String {

        var first = "empty"
        if let photo = photos.photo.first {
            first = "\(photo)"
        }

        // multi-line string syntax
        return """
        stat: \(stat),
        photos:
         > page: \(photos.page),
         > pages: \(photos.pages),
         > perpage: \(photos.perpage),
         > total: \(photos.total),
         > photos: count: \(photos.photo.count),
         > first: \(first)
        """
    }
}
