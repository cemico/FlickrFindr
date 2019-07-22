//
//  FlickrError.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

struct FlickrError: Decodable {

    // string / enum support, avoid embedded strings for cleaner
    // and easier to maintain code, avoiding duplicity, etc.
    enum Status: String {

        case fail
        case pass = "ok"
    }

    // constants should always appear at the top
    // scope closest to usage for maintainability,
    // visibility, and exposure, as hard coded
    // values shold only be used when absolutely necessary
    private struct Constants {

        static let internalErrorCode = 999
    }

    // ex) "stat":"fail","code":100,"message":"Invalid API Key (Key has invalid format)"
    let code: Int
    let stat: String
    let message: String

    // custom init translating Error to FlickrError
    init(error: Error) {

        self.code = Constants.internalErrorCode
        self.stat = Status.fail.rawValue
        self.message = error.localizedDescription
    }
}

extension FlickrError: CustomStringConvertible {

    var description: String {

        // more details, similar to debugPrint which maps to CustomDebugStringConvertible
        return "stat: \(stat), code: \(code), message: \(message)"
    }
}
