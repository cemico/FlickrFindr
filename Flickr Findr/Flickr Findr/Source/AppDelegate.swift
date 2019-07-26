//
//  AppDelegate.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // example of delayed init to prevent need for optional
    lazy var apiService: APIRequirements = {
       
        return APIServiceFactory().createNetwork(from: .arg)
    }()

    lazy var localStorageService: LocalStorageProtocol = {

        return LocalStorage()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // setup network layer, default is real / live network, but
        // allows for the possibility to setting up a test / mock network
        print("Network: \(type(of: apiService))")
        
        return true
    }
}

extension UIApplication {
    
    func getDelegate() -> AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }

    // these really need a better home, such as a service protocol w/ a live
    // implementation of below, allowing yet another level of control and
    // not requiring UIKit imports on files which really don't need it.
    var apiService: APIRequirements {
        
        return getDelegate().apiService
    }

    var localStorageService: LocalStorageProtocol {

        return getDelegate().localStorageService
    }
}
