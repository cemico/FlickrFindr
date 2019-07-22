//
//  FlickrPhotos.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// model class for subset of: https://www.flickr.com/services/api/flickr.photos.search.html
struct FlickrPhotos: Decodable {

    // count related
    let page: Int
    let pages: Int
    let perpage: Int

    // not very consistent, search has this as String, recent has it as an int...
    // thus the need for the init below to manually get proper type, otherwise
    // no need for CodingKeys and init
    let total: Int

    // data
    let photo: [FlickrPhoto]

    enum CodingKeys: String, CodingKey {

        case page, pages, perpage, photo
        case total
    }

    init(from decoder: Decoder) throws {

        // handle multiple types for total property to account for String and Int
        do {

            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let stringProperty = try? container.decode(String.self, forKey: .total) {

                // note: nil coallescing example
                total = Int(stringProperty) ?? 0
            }
            else if let intProperty = try? container.decode(Int.self, forKey: .total) {

                total = intProperty
            }
            else {

                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not String or Int"))
            }

            // remaining keys decode properly
            page = try container.decode(Int.self, forKey: .page)
            pages = try container.decode(Int.self, forKey: .pages)
            perpage = try container.decode(Int.self, forKey: .perpage)
            photo = try container.decode([FlickrPhoto].self, forKey: .photo)
        }
    }
}

extension FlickrPhotos: CustomStringConvertible {

    var description: String {

        // more details, similar to debugPrint which maps to CustomDebugStringConvertible
        return "page: \(page), pages: \(pages), perpage: \(perpage), total: \(total), photos: \(photo.count)"
    }
}
