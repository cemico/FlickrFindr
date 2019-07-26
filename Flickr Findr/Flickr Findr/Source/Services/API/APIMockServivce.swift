//
//  APIMockServivce.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/22/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

class APIMockService: APIRequirements {
    
    private struct Constants {
        
        static let isAsync = false
        static let asyncDelayInMS = 3000
        static let isError = false
    }
    
    // set of testing options to allow the
    // injected mock network to explore all
    // the possibilties, both success and failure
    
    // allow test to run in sync or async modes
    var isAsync = Constants.isAsync
    
    // allow to simulate network latency
    var asyncDelayInMS = Constants.asyncDelayInMS
    
    // allow error return
    var isError = Constants.isError
    
    // allow full customization for results, successful and error
    typealias APIMockResultsSource = (bundle: String?, custom: String?)
    var results: APIMockResultsSource = (nil, nil)
    
    func search(with tags: String,
                exclusive: Bool,
                page: Int,
                completionHandler: @escaping (FlickrResults<FlickrSearch>) -> Void) {

        // extract dynamic test case number / folder
        let testCase = CommandLine.testNumberArgValue

        // load mock file
        let results =  FileManager.default.jsonFile(value: FlickrSearch.self,
                                                    for: testCase,
                                                    of: .search,
                                                    isError: isError)

        // chain to caller
        completionHandler(results)
    }

    func photoInfo(id: String,
                   secret: String,
                   completionHandler: @escaping (FlickrResults<FlickrPhoto>) -> Void) {
        

        // extract dynamic test case number / folder
        let testCase = CommandLine.testNumberArgValue

        // load mock file
        let results =  FileManager.default.jsonFile(value: FlickrPhoto.self,
                                                    for: testCase,
                                                    of: .photoInfo,
                                                    isError: isError)

        // chain to caller
        completionHandler(results)
    }
    
    func recent(page: Int = 1,
                completionHandler: @escaping (FlickrResults<FlickrRecent>) -> Void) {

        // extract dynamic test case number / folder
        let testCase = CommandLine.testNumberArgValue

        // load mock file
        let results =  FileManager.default.jsonFile(value: FlickrRecent.self,
                                                    for: testCase,
                                                    of: .recent,
                                                    isError: isError)

        // chain to caller
        completionHandler(results)
    }
}
