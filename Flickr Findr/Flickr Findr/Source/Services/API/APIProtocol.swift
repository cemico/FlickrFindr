//
//  APIProtocol.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/22/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

protocol APIRequirements {
    
    // tags: comma delineated, default empty
    // exclusive: tags OR or AND, default OR
    // page to view, default 1
    func search(with tags: String,
                exclusive: Bool,
                page: Int,
                completionHandler: @escaping (FlickrResults<FlickrSearch>) -> Void)
    
    // info on specific photo
    func photoInfo(id: String,
                   secret: String,
                   completionHandler: @escaping (FlickrResults<FlickrPhoto>) -> Void)
    
    // give the user something to see on first launch - recent photo postings
    func recent(page: Int,
                completionHandler: @escaping (FlickrResults<FlickrRecent>) -> Void)
}
