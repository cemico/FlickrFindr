//
//  UserDefaultsExt.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/23/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    private struct Constants {
        
        static let numThumbImagesPerRow = 3
    }
    
    // note: avoid extra key by reusing unique var declaration
    var numThumbImagesPerRow: Int {
        
        get {
            guard let value = object(forKey: #function) as? Int else {
                
                // default
                return Constants.numThumbImagesPerRow
            }
            return value
        }
        set { set(newValue, forKey: #function) }
    }

    var mruSearchHistory: [String] {
        
        get {
            
            guard let value = object(forKey: #function) as? [String] else {
                
//                // note: initially had a dict w/ index as key,
//                //         cool code, so left for reviewer ;)
//                //
//                // range, trailing closure, and snazzy reduce examples
//                var dict = (1...mruCount).reduce(into: [:]) { (counts, index) in
//                    counts[index] = ""
//                }

                // save
                let emptyHistory: [String] = []
                self.mruSearchHistory = emptyHistory
                
                return emptyHistory
            }
            return value
        }
        
        set {
            
            setValue(newValue, forKey: #function)
        }
    }
}
