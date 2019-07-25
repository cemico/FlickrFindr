//
//  CommandLineExt.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/22/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// let's make it easier to check for specific cmdline parms
// args take the format of xxx=yyy, where xxx is the key
// and yyy is the value

extension CommandLine {

    enum Separators: Character {
        
        case equal = "="
    }
    
    enum Keys: String {
        
        // working w/ the network class factory, our possible
        // network service combinations would be:
        //
        // a) mock: valid "network" key with value of "mock"
        // b) live: all other combinations / default
        //
        // note: if duplicate keys, first is used
        case network
    }
    
    static var networkArgValue: String? {
        
        return CommandLine.getValue(for: .network)
    }
    
    static func getValue(for key: Keys) -> String? {
        
        // get first match
        let key = key.rawValue
        guard let arg = CommandLine.arguments.filter({ $0.hasPrefix(key) }).first else { return nil }
        
        // return value
        let pieces = arg.split(separator: Separators.equal.rawValue)
        guard pieces.count == 2 else { return nil }
        
        // substring to string
        return String(pieces[1])
    }
}
