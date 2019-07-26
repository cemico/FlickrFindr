//
//  APIMockDataSourceProtocol.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/26/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

protocol APIMockDataSourceProtocol {

    // properties

    // allow test to run in sync or async modes
    var isAsync: Bool { get set }

    // allow to simulate network latency
    var asyncDelayInMS: Int { get set }

    // allow error return
    var isError: Bool { get set }

    // test case number, for file based mocking, part of bundled folder name
    var testCase: Int { get set }

    // API
    func search(with tags: String,
                exclusive: Bool,
                page: Int,
                completionHandler: @escaping (FlickrResults<FlickrSearch>) -> Void)

    func photoInfo(id: String,
                   secret: String,
                   completionHandler: @escaping (FlickrResults<FlickrPhoto>) -> Void)

    func recent(page: Int,
                completionHandler: @escaping (FlickrResults<FlickrRecent>) -> Void)
}
