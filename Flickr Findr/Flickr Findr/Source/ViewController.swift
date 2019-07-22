//
//  ViewController.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // search photos, trailing closure example
        let exclusive = APIEndpoints.ExclusiveValues.or.value
        let page = "1"
        APIEndpoints.search("orchid,green", exclusive, page).getData(value: FlickrSearch.self) { results in

            switch results {

            case .success(let model):
                print("success model \(type(of: model.self)):", model)

            case .failure(let error):
                print(error)
            }
        }

        // recent photos
//        APIEndpoints.recent.getData(value: FlickrRecent.self) { results in
//
//            switch results {
//
//            case .success(let model):
//                print("success model \(type(of: model.self)):", model)
//
//            case .failure(let error):
//                print(error)
//            }
//        }

        // photo info
//        APIEndpoints.photoInfo("24379963431", "027546fe5d").getData(value: FlickrPhoto.self) { results in
//
//            switch results {
//
//            case .success(let model):
//                print("success model \(type(of: model.self)):", model)
//
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}

