//
//  ViewControllerInstanciator.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/23/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

enum Storyboards: String {
    
    case main = "Main"
}

protocol ViewControllerInstanciator {
    
    // nib
    static func fromNib(_ name: String,
                        in bundle: Bundle) -> Self?
    
    // storyboard
    static func fromSB(_ name: Storyboards,
                       with id: String,
                       in bundle: Bundle) -> Self?
}

// cleaned up version of very nifty routine ran across year or two back
extension ViewControllerInstanciator where Self: UIViewController {
    
    static func fromNib(_ name: String = className,
                        in bundle: Bundle = .main) -> Self? {
        
        return Self(nibName: name, bundle: bundle)
    }
    
    static func fromSB(_ name: Storyboards = .main,
                       with id: String = className,
                       in bundle: Bundle = .main) -> Self? {
        
        // note: assumes storyboard Id is name of view controller
        let storyboardId = id
        
        // load our storyboard
        let storyboard = UIStoryboard(name: name.rawValue, bundle: bundle)
        
        // note: dynamic Self return
        return storyboard.instantiateViewController(withIdentifier: storyboardId) as? Self
    }
}
