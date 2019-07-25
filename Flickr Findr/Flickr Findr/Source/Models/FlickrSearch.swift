//
//  FlickrSearch.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// common format between search, recent, and popular
protocol FlickrPhotosDecodale: Decodable {

    // results related
    var photos: FlickrPhotos { get }

    // success related
    var stat: String  { get }
}

// model class for: https://www.flickr.com/services/api/flickr.photos.search.html
struct FlickrSearch: FlickrPhotosDecodale {

    // protocol conformance
    
    // results related
    private(set) var photos: FlickrPhotos

    // success related
    private(set) var stat: String
}

// custom output
extension FlickrSearch: CustomStringConvertible {

    var description: String {

        var first = "empty"
        if let photo = photos.photo.first {
            first = "\(photo)"
        }

        // swift 4s snazzy multi-line string syntax
        return """
        stat: \(stat),
        photos:
         > page: \(photos.page),
         > pages: \(photos.pages),
         > perpage: \(photos.perpage),
         > total: \(photos.total),
         > photos count: \(photos.photo.count),
         > first photo: \(first)
        """
    }
}

// localized protocol optional constants
//
// i.e. best practices has constants declared non-inline, encapsulated, and moreso,
//      best practices has policies for precedence given towards readability and maintainability
//      both of these strongly suggest that any magic numbers, i.e. constants embedded in the code
//      should be exposed and made visible in a central area, local to the scope, but encapsulated at it's closest level,
//      allowing developer x, down the road, to quicly see any configurable / assumed args, versus
//      potentially assuming there are none and missing embedded values
//      a protocol cannot have local scope defaults, thus fileprivate
fileprivate struct FlickrSearchArgConstants {

    static let tags: [String] = []
    static let format = "json"
}

// app specific arguments into api
protocol FlickrSearchArguments {

    // required
    var apiKey: String { get }

    // optional / assumed defaults
    var tags: [String] { get }
    var format: String { get }
}

// objc was a bit cleaner w/ the @optional attribute
extension FlickrSearchArguments {

    // extend default values / create optional values
    var tags: [String] { return FlickrSearchArgConstants.tags }
    var format: String { return FlickrSearchArgConstants.format }
}
