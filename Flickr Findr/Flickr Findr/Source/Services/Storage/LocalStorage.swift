//
//  LocalStorage.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/26/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

// protocol wrapper so unit testing can provide it's own flavor if needed
struct LocalStorage: LocalStorageProtocol {


    var numThumbImagesPerRow: Int {

        get { return UserDefaults.standard.numThumbImagesPerRow }
        set { UserDefaults.standard.numThumbImagesPerRow = newValue }
    }

    var numberItemsInAPIRequest: Int {

        get { return UserDefaults.standard.numberItemsInAPIRequest }
        set { UserDefaults.standard.numberItemsInAPIRequest = newValue }
    }

    var exclusiveAndSearches: Bool {

        get { return UserDefaults.standard.exclusiveAndSearches }
        set { UserDefaults.standard.exclusiveAndSearches = newValue }
    }

    var mruSearchHistory: [String] {

        get { return UserDefaults.standard.mruSearchHistory }
        set { UserDefaults.standard.mruSearchHistory = newValue }
    }
}
