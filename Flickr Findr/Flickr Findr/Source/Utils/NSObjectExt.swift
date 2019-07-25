//
//  NSObjectExt.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/23/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

extension NSObject {
    
    // computed properties
    var className: String {
        
        return type(of: self).className
    }
    
    // static
    static var className: String {
        
        return String(describing: self)
    }
}
