//
//  LocalStorageProtocol.com.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/26/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

protocol LocalStorageProtocol {

    var numThumbImagesPerRow: Int { get set }
    var numberItemsInAPIRequest: Int { get set }
    var exclusiveAndSearches: Bool { get set }
    var mruSearchHistory: [String] { get set }
}
