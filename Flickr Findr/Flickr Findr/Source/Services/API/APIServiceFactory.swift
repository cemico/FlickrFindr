//
//  APIServiceFactory.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/22/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// two things of importance here, one is the type of
// network we want to create, and the second is the
// area where we determine this type.
//
// for the type, we naturally have "live", but also
// at least one form of a "mock" network.  multiple
// variations could exist.
//
// the area, or how we look for which type to create,
// can come from any number of sources, from commandline
// argument, from environment vars, from online config
// urls, from locally bundled text file, etc.
// the most common is the commandline arg, which lends
// itself to easy specificiation by xcrun simctl running.

// create a network source
class APIServiceFactory {
    
    // enum iteration *much* simplier since new protocol
    enum NetworkSource: String, CaseIterable {
        
        case live   // default
        case mock
        
        // simple wrapper
        static func convert(key: String) -> NetworkSource? {
            
            // case insensitive to match our all-lower case
            return NetworkSource(rawValue: key.lowercased())
        }
    }
    
    enum NetworkSourceTrigger {
        
        case none   // default (don't look for any alternatives, use default source)
        case arg
    }
    
    enum NetworkKey {
        
        case arg(String, String)
    }
    
    func createNetwork(from trigger: NetworkSourceTrigger) -> APIRequirements {
        
        // check for default cases
        guard trigger != .none else { return createNetwork(from: .live) }
        
        // need to check the source to see if
        // a) source is specified
        // b) source is valid mock
        // c) create valid mock, otherwise live
        return createNetworkFromArg()
    }
    
    private func createNetwork(from source: NetworkSource) -> APIRequirements {
        
        switch source {
            
        case .live:     return APILiveService()

        // future add could be to support multiple mock sources from cmdline
        case .mock:     return APIMockService(dataSource: APIMockFileDataSource())
        }
    }
    
    private func createNetworkFromArg() -> APIRequirements {
        
        // check if command line exists
        if let networkValue = CommandLine.networkArgValue {
            
            // key and arg exist, validate value
            if let networkSource = NetworkSource.convert(key: networkValue) {
                
                // valid key/value
                return createNetwork(from: networkSource)
            }
        }
        
        // default to live
        return createNetwork(from: .live)
    }
}
