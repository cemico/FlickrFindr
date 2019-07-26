//
//  APIMockServivce.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/22/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

class APIMockService: APIRequirements {

    // properties
    private let dataSource: APIMockDataSourceProtocol

    // lifecycle
    init(dataSource: APIMockDataSourceProtocol) {

        self.dataSource = dataSource
    }

    // protocol conformance
    func search(with tags: String,
                exclusive: Bool,
                page: Int,
                completionHandler: @escaping (FlickrResults<FlickrSearch>) -> Void) {


        // data source to work it's specificity
        dataSource.search(with: tags,
                          exclusive: exclusive,
                          page: page,
                          completionHandler: completionHandler)
    }

    func photoInfo(id: String,
                   secret: String,
                   completionHandler: @escaping (FlickrResults<FlickrPhoto>) -> Void) {
        
        // source specific
        dataSource.photoInfo(id: id, secret: secret, completionHandler: completionHandler)
    }
    
    func recent(page: Int = 1,
                completionHandler: @escaping (FlickrResults<FlickrRecent>) -> Void) {

        // source specific
        dataSource.recent(page: page, completionHandler: completionHandler)
    }
}
