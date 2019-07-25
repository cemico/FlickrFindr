//
//  FileManagerExt.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/22/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// setup custom errors for below
enum FileManagerError: Error {
    
    case noResourceURL, badPath, unableToModel, unableToRead
}

extension FileManager {
    
    private enum Constants: String {
        
        case json, test, data, error
        
        var capFirst: String { return self.rawValue.capitalized }
    }
    
    private enum TestFileTypes: String {
        
        case photoInfo, search, recent
    }
    
    // generic return type for the json-based loads below
    typealias FlickrLoadTestResultsType<T> = (model: T?, error: FlickrError?)

    // by search
    func loadSearchTestFile(for testCase: Int, isError: Bool) -> FlickrLoadTestResultsType<FlickrSearch> {
        
        return jsonFile(value: FlickrSearch.self,
                        for: testCase,
                        of: .search,
                        isError: isError)
    }
    
    // by photo info
    func loadPhotoInfoTestFile(for testCase: Int, isError: Bool) -> FlickrLoadTestResultsType<FlickrPhoto> {
        
        return jsonFile(value: FlickrPhoto.self,
                        for: testCase,
                        of: .photoInfo,
                        isError: isError)
    }
    
    // by recent
    func loadRecentTestFile(for testCase: Int, isError: Bool) -> FlickrLoadTestResultsType<FlickrRecent> {
        
        return jsonFile(value: FlickrRecent.self,
                        for: testCase,
                        of: .recent,
                        isError: isError)
    }
}

extension FileManager {
    
    // private helpers
    private func jsonFile<T: Decodable>(value: T.Type,
                                        for testCase: Int,
                                        of testType: TestFileTypes,
                                        isError: Bool,
                                        in bundle: Bundle = Bundle.main) -> (T?, FlickrError?) {

        // resources must exist for given bundle
        guard let resourceURL = bundle.resourceURL else {
            
            let flickrError = FlickrError(error: FileManagerError.noResourceURL)
            return (nil, flickrError)
        }
        
        // file and folder (/.../Data/Testxx)
        let dataFolder = "\(Constants.data.capFirst)"
        let testFolder = "\(Constants.test.capFirst)"
        let folder = dataFolder + "/" + testFolder + "\(testCase)"
        let error = (isError ? Constants.error.capFirst : "")
        let filename = "\(testType.rawValue)\(error).\(Constants.json.rawValue)"
        
        // validate file exists
        var urlPath = resourceURL.appendingPathComponent(folder)
        guard !urlPath.path.isEmpty else {
            
            let flickrError = FlickrError(error: FileManagerError.badPath)
            return (nil, flickrError)
        }
        
        // update w/ filename
        urlPath.appendPathComponent(filename)
        
        // read file
        guard let data = FileManager.default.contents(atPath: urlPath.path) else {

            let flickrError = FlickrError(error: FileManagerError.unableToRead)
            return (nil, flickrError)
        }

        do {

            // serialize to model
            if isError {
                
                // error data model
                let model = try JSONDecoder().decode(FlickrError.self, from: data)

                // success w/ valid error model
                return (nil, model)
            }
            else {
                
                // normal data model
                let model = try JSONDecoder().decode(T.self, from: data)

                // success w/ valid data model
                return (model, nil)
            }
        }
        catch {
            
            print(error.localizedDescription)
            let flickrError = FlickrError(error: FileManagerError.unableToModel)
            return (nil, flickrError)
        }
    }
}
