//
//  DispatchQueueExt.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/24/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    func mainInline(on dispatchAsyncIfNotMain: Bool = true, execute work: @escaping () -> Void) {
        
        // execute inline / immediately / sync if already on main queue
        guard !Thread.current.isMainThread else {

            work()
            return
        }
        
        // not on main queue, provide both options
        if dispatchAsyncIfNotMain {

            DispatchQueue.main.async {
                
                work()
            }
        }
        else {

            DispatchQueue.main.sync {

                work()
            }
        }
    }
}
