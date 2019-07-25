//
//  FlickrPhoto.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// model class for: https://www.flickr.com/services/api/flickr.photos.getInfo.html
// note: Decoable protocol, no need for Codable protocol composition, as we are not encoding anything
struct FlickrPhoto: Decodable {

    // note: use of constants since model class does not modify and JSON decoder initializes 
    //       values on init() using struct default initializer of each struct member
    let id: String
    let title: String

    // used in image url composition
    let secret: String
    let farm: String
    let server: String
    
    // the photo array from the search return differs in syntax
    // the photo info direct call.  however, they only differ
    // by a root "photo" key, so expand the default logic to
    // manually look for both
    enum CodingKeys: String, CodingKey {

        case photo, id, secret, title, farm, server
    }

    init(from decoder: Decoder) throws {

        // keys exist either at the root container or at the first child photo container
        do {

            // try root container
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let id = try? container.decode(String.self, forKey: .id) {

                // yes - root level
                self.id = id
                secret = try container.decode(String.self, forKey: .secret)
                title = try container.decode(String.self, forKey: .title)
                server = try container.decode(String.self, forKey: .server)
                let farmInt = try container.decode(Int.self, forKey: .farm)
                farm = "\(farmInt)"
            }
            else {

                // no - try child photo level
                let photoContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .photo)
                id = try photoContainer.decode(String.self, forKey: .id)
                secret = try photoContainer.decode(String.self, forKey: .secret)
                server = try photoContainer.decode(String.self, forKey: .server)
                let farmInt = try photoContainer.decode(Int.self, forKey: .farm)
                farm = "\(farmInt)"

                // note: title is a dictionary in this path versus string above, translate
                let dict = try photoContainer.decode([String: String].self, forKey: .title)
                title = dict["_content", default: ""]
            }
        }
    }
}

// custom output
extension FlickrPhoto: CustomStringConvertible {

    var description: String {

        return "id: \(id), title: \(title), secret: \(secret), farm: \(farm), server: \(server)"
    }
}
