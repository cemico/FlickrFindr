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
    
    lazy var thumbPhotoSize: FlickrPhotoVM.PhotoSize = {
       
        // determine the thumb size by device size
        let numberThumbsHorizontally = UserDefaults.standard.numThumbImagesPerRow
        let deviceWidth = UIScreen.main.bounds.width.intValue
        let maxThumbWidth = deviceWidth / numberThumbsHorizontally
        return FlickrPhotoVM.PhotoSize.format(from: maxThumbWidth)
    }()

    private lazy var imagePhotoSize: FlickrPhotoVM.PhotoSize = {
        
        // determine the optimal image size by device size
        let deviceWidth = UIScreen.main.bounds.width.intValue
        return FlickrPhotoVM.PhotoSize.format(from: deviceWidth)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // setup network layer, default is real / live network, but
        // allows for the possibility to setting up a test / mock network
        print("Network: \(type(of: apiService))")
        
        print("Thumb Size: \(thumbPhotoSize), Image Size: \(imagePhotoSize)")

        return true
    }
}

extension UIApplication {
    
    func getDelegate() -> AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var apiService: APIRequirements {
        
        return getDelegate().apiService
    }
    
    var thumbPhotoSize: Int {
        
        return getDelegate().thumbPhotoSize.format.size
    }
}
