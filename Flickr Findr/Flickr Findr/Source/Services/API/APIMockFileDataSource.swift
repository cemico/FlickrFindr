//
//  APIMockFileDataSource.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/26/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

struct APIMockFileDataSource: APIMockDataSourceProtocol {

    // constants (specific to this data source's implementation)
    private struct Constants {

        static let isAsync = false
        static let asyncDelayInMS = 3000
        static let isError = false
    }

    // properties - protocol conformance

    // allow test to run in sync or async modes
    var isAsync: Bool

    // allow to simulate network latency
    var asyncDelayInMS: Int

    // allow error return
    var isError: Bool

    // test folder to look for mock data
    var testCase: Int

    // lifecycle
    init() {

        // default initializer
        self.isAsync = Constants.isAsync
        self.asyncDelayInMS = Constants.asyncDelayInMS
        self.isError = Constants.isError
        self.testCase = CommandLine.testNumberArgValue
    }

    // allow customizations
    init(isAsync: Bool = Constants.isAsync,
         asyncDelayInMS: Int = Constants.asyncDelayInMS,
         isError: Bool = Constants.isError,
         testCase: Int) {

        self.isAsync = isAsync
        self.asyncDelayInMS = asyncDelayInMS
        self.isError = isError
        self.testCase = CommandLine.testNumberArgValue
    }

    // api conformance
    func search(with tags: String,
                exclusive: Bool,
                page: Int,
                completionHandler: @escaping (FlickrResults<FlickrSearch>) -> Void) {

        // load mock file
        let results =  FileManager.default.jsonFile(value: FlickrSearch.self,
                                                    for: testCase,
                                                    of: .search,
                                                    isError: isError)

        // chain to caller
        DispatchQueue.main.async {

            completionHandler(results)
        }
    }

    func photoInfo(id: String, secret: String, completionHandler: @escaping (FlickrResults<FlickrPhoto>) -> Void) {

        // load mock file
        let results =  FileManager.default.jsonFile(value: FlickrPhoto.self,
                                                    for: testCase,
                                                    of: .photoInfo,
                                                    isError: isError)

        // chain to caller
        DispatchQueue.main.async {

            completionHandler(results)
        }
    }

    func recent(page: Int, completionHandler: @escaping (FlickrResults<FlickrRecent>) -> Void) {

        // load mock file
        let results =  FileManager.default.jsonFile(value: FlickrRecent.self,
                                                    for: testCase,
                                                    of: .recent,
                                                    isError: isError)

        // chain to caller
        DispatchQueue.main.async {

            completionHandler(results)
        }
    }
}
