//
//  ResultsWrapper.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// setup custom errors for below
enum ResultsError: Error {

    case unknown, noData, badURL, badInput
}

// allow readable representation
extension ResultsError: CustomStringConvertible {

    // unable to setup RawRepresentable which has two sides to
    // conform too, the input (i.e. init) and 
    // output (i.e. in our case, the string).
    // with the input being any string ... doesn't work so well
    // when you could have potentially any number of case values.
    var description: String {

        switch self {

        case .unknown:  return "Unknown failure state before performing decode operation"
        case .noData:   return "No Data returned"
        case .badURL:   return "Unable to form URL"
        case .badInput: return "Bad or missing input"
        }
    }

    var flickrError: FlickrError {

        // mapper
        return FlickrError(error: self)
    }
}

// create a generic results wrapper, with our intended usage
// to encapsulate a typical online response within an enum,
// allowing for success (some data typicall) / failure (error)
// note: Swift 5 has similar as base functionality
enum FlickrResults<Value> {

    // any specific success data
    case success(Value)

    // mapped flickr specific error
    case failure(FlickrError)
}

//  helpful mapping routines
extension FlickrResults {

    // map: ResultsError -> FlickrResults
    static func failure(from error: ResultsError) -> FlickrResults<Value> {

        // get flickrError
        let flickrError = error.flickrError

        // results failure
        return results(from: flickrError)
    }

    // map: Error -> FlickrResults
    static func failure(from error: Error) -> FlickrResults<Value> {

        // get flickrError
        let flickrError = FlickrError(error: error)

        // results failure
        return results(from: flickrError)
    }

    // map: FlickrError -> FlickrResults
    static func failure(from flickrError: FlickrError) -> FlickrResults<Value> {

        // results failure
        return results(from: flickrError)
    }
}

private extension FlickrResults {

    // helpers
    static func results(from flickrError: FlickrError) -> FlickrResults<Value> {

        // setup results failure
        return FlickrResults<Value>.failure(flickrError)
    }
}

//extension Results where Value == Data {
//
//    // our specific usage is to handle success for online calls, where
//    // we receive either Data or an Error - prevent duplication by
//    // extending the class (Decorator pattern)
//
//    // generally same signature as Decode, pass and return T or throw error
//    static func decode<T: Decodable>(data: Data?, error: Error?) -> Results<T> {
//
//        // not so common, but purely for swift knowledge example,
//        // swift can have any levels of functions with functions
//        // to encompasule at a level even further than 'private'
//        // if I was coding this for production, I'd put these as
//        // private extension functions to reduce overall function size
//        func checkForError(data: Data?, error: Error?) -> FlickrError? {
//
//            // hopefully our common non-error path
//            guard let error = error else { return nil }
//
//            // check for specific error from server
//            if let dataErr = data {
//
//                do {
//
//                    // check for specific error
//                    let flickrError = try JSONDecoder().decode(FlickrError.self, from: dataErr)
//                    return flickrError
//                }
//                catch { }
//            }
//
//            // have error, translate into local error
//            return FlickrError(error: error)
//        }
//
//        // what's swift without a tuple example ;)
//        typealias SerializeDataType = (value: T?, error: FlickrError?)
//        func serializeData(data: Data?, cls: T) -> SerializeDataType {
//
//            // generic error
//            let flickrError = FlickrError(error: ResultsError.unknown)
//            let errorTuple = SerializeDataType(value: nil, error: flickrError)
//
//            // must have data
//            guard let data = data else {
//
//                return errorTuple
//            }
//
//            // serialize
//            do {
//
//                let results = try JSONDecoder().decode(T.self, from: data)
//                return (value: results, error: nil)
//            }
//            catch {
//
//                print("error decoding Flickr response:", error)
//                do {
//
//                    // old school, pre-swift 4 way to serialize response data
//                    // help dev with more info
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    guard let results = json else { return errorTuple }
//
//                    // example of multiple prints on same line
//                    print("Likely server data types have changed - update to match, ", terminator: "")
//                    print("Physical results:", results)
//
//                    // check data for actual specific flickr error
//                    let flickrError = try? JSONDecoder().decode(FlickrError.self, from: data)
//                    return (value: nil, error: flickrError)
//                }
//                catch {
//
//                    print("Unable to serialize data, \(data.count) bytes returned")
//                }
//
//                return errorTuple
//            }
//        }
//
//        // w/ the encapsulated support functions, non-cluttered workflow on core logic
//
//        // check 1 - validate no error
//        if let flickrError = checkForError(data: data, error: error) {
//
//            // error was not nil
//            return Results<T>.failure(flickrError)
//        }
//
//        // check 2 - validate seriliazation of data
//        let results = serializeData(data: data, cls: T)
//        if let flickrError = results.error {
//
//            // error on serialization
//            return Results<T>.failure(flickrError)
//        }
//
//        // check 3 - make sure valid serialized value
//        guard let output = results.value else {
//
//            let flickrError = FlickrError(error: ResultsError.unknown)
//            return Results<T>.failure(flickrError)
//        }
//
//        // success
//        return Results<T>.success(output)
//
//
//
//
////        // since we are an associated value enum,
////        // need to extract true Data from within ourselves
////        // could use switch, but we don't care for error
////        // yet, since we haven't performed our operation,
////        // istead use swift 4's nice pattern matching
////        if case let Results.success(data) = self {
////
////            // swift 4 introduced Codable which is protocol composition
////            // for both Encodable and Decodable
////            return try JSONDecoder().decode(T.self, from: data)
////        }
////        else {
////
////            // unknown state, in failure case before test
////            // setup custom error and return
////            let error = ResultsError.unknown
////            print(error)
////            throw error
////        }
//    }
//}
