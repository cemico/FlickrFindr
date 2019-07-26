//
//  APIMockInputDataSource.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/26/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

struct APIMockInputDataSource: APIMockDataSourceProtocol {

    // constants (specific to this data source's implementation)
    private struct Constants {

        static let isAsync = true
        static let asyncDelayInMS = 3000
        static let isError = false
    }

    // properties - protocol conformance, note var required on protocol variable

    // allow test to run in sync or async modes
    var isAsync: Bool

    // allow to simulate network latency
    var asyncDelayInMS: Int

    // allow error return
    var isError: Bool

    // test folder to look for mock data
    var testCase: Int

    // local properties
    private var model: Decodable?
    private var error: FlickrError?

    // lifecycle
    init() {

        // default initializer
        self.isAsync = Constants.isAsync
        self.asyncDelayInMS = Constants.asyncDelayInMS
        self.isError = Constants.isError
        self.testCase = CommandLine.testNumberArgValue
    }

    init(model: Decodable?, error: FlickrError?) {

        self.init()
        self.model = model
        self.error = error
    }

    // api conformance
    func search(with tags: String,
                exclusive: Bool,
                page: Int,
                completionHandler: @escaping (FlickrResults<FlickrSearch>) -> Void) {

        let dispatch = { (results: (FlickrResults<FlickrSearch>)) in

            DispatchQueue.main.async {

                completionHandler(results)
            }
        }

        // check for success
        guard let model = model as? FlickrSearch else {

            // check for supplied error
            if let flickrError = error {

                // package and chain to caller
                let results = FlickrResults<FlickrSearch>.failure(flickrError)
                dispatch(results)
            }
            else {

                // both invalid, return generic error
                let flickrError = FlickrError(error: ResultsError.badInput)
                let results = FlickrResults<FlickrSearch>.failure(flickrError)
                dispatch(results)
            }
            return
        }

        // package and chain to caller
        let results = FlickrResults<FlickrSearch>.success(model)
        dispatch(results)
    }

    func photoInfo(id: String, secret: String, completionHandler: @escaping (FlickrResults<FlickrPhoto>) -> Void) {

        let dispatch = { (results: (FlickrResults<FlickrPhoto>)) in

            DispatchQueue.main.async {

                completionHandler(results)
            }
        }

        // check for success
        guard let model = model as? FlickrPhoto else {

            // check for supplied error
            if let flickrError = error {

                // package and chain to caller
                let results = FlickrResults<FlickrPhoto>.failure(flickrError)
                dispatch(results)
            }
            else {

                // both invalid, return generic error
                let flickrError = FlickrError(error: ResultsError.badInput)
                let results = FlickrResults<FlickrPhoto>.failure(flickrError)
                dispatch(results)
            }
            return
        }

        // package and chain to caller
        let results = FlickrResults<FlickrPhoto>.success(model)
        dispatch(results)

//        handleResults(value: FlickrPhoto.self) { (results: FlickrResults<FlickrPhoto>) in
//
//            DispatchQueue.main.async {
//
//                completionHandler(results)
//            }
//        }
    }

    func recent(page: Int, completionHandler: @escaping (FlickrResults<FlickrRecent>) -> Void) {

        let dispatch = { (results: (FlickrResults<FlickrRecent>)) in

            DispatchQueue.main.async {

                completionHandler(results)
            }
        }

        // check for success
        guard let model = model as? FlickrRecent else {

            // check for supplied error
            if let flickrError = error {

                // package and chain to caller
                let results = FlickrResults<FlickrRecent>.failure(flickrError)
                dispatch(results)
            }
            else {

                // both invalid, return generic error
                let flickrError = FlickrError(error: ResultsError.badInput)
                let results = FlickrResults<FlickrRecent>.failure(flickrError)
                dispatch(results)
            }
            return
        }

        // package and chain to caller
        let results = FlickrResults<FlickrRecent>.success(model)
        dispatch(results)
    }
}

// private helpers
extension APIMockInputDataSource {

    private func handleResults<T>(value: T, completionHandler: (FlickrResults<T>) -> Void) {

        // check for success
        guard let model = model as? T else {

            // check for supplied error
            if let flickrError = error {

                // package and chain to caller
                let results = FlickrResults<T>.failure(flickrError)
                completionHandler(results)
            }
            else {

                // both invalid, return generic error
                let flickrError = FlickrError(error: ResultsError.badInput)
                let results = FlickrResults<T>.failure(flickrError)
                completionHandler(results)
            }
            return
        }

        // package and chain to caller
        let results = FlickrResults<T>.success(model)
        completionHandler(results)
    }
}
