//
//  MRUSearchHistory.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/23/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

struct MRUSearchHistory {
    
    private let maxHistoryCount = 25
    private(set) var history: [String] = []
    
    // limit to one instance w/ private init, singleton pattern
    static let shared = MRUSearchHistory()
    private init() {
    
        // retrieve any previous history
        history = UserDefaults.standard.mruSearchHistory
    }
    
    // note: mutating example
    mutating func add(search: String) {
        
        // multi-thread save
        NSLock().synchronized {
            
            // no dups, and unlike Set, want it reorder on dup hit
            history.removeAll { $0 == search }
            
            // add at top, i.e. most recent
            history.insert(search, at: 0)
            
            // trim if needed
            let size = history.count
            if size > maxHistoryCount {
                
                history.removeLast(size - maxHistoryCount)
            }
        }
    }
}
