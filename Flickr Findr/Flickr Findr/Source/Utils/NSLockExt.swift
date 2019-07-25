//
//  NSLockExt.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/23/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// nifty little extension used for some time now
// note: psudo-clip from https://gist.github.com/kristopherjohnson/d12877ee9a901867f599
extension NSLock {
    
    // auto lock/unlock wrapper around closure
    func synchronized(_ criticalSection: () -> Void) {
        
        self.lock()
        criticalSection()
        self.unlock()
    }
    
    // auto lock/unlock wrapper around closure
    func synchronizedResult<T>(_ criticalSection: () -> T) -> T {
        
        self.lock()
        let result = criticalSection()
        self.unlock()
        
        return result
    }
}
