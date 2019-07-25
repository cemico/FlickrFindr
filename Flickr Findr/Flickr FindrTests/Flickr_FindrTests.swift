//
//  Flickr_FindrTests.swift
//  Flickr FindrTests
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import XCTest
@testable import Flickr_Findr

class Flickr_FindrTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {

        // 1 - test photo vm format calcs
        
        //                for size in FlickrPhotoVM.PhotoSize.allCases {
        //
        //                    print(size, "(\(size.format.letter)):", vm.getImageURL(for: size.format.size + 2))
        //                }

        // search photos, trailing closure example
        //        let exclusive = APIEndpoints.ExclusiveValues.or.value
        //        let page = "1"
        //        APIEndpoints.search("orchid,green", exclusive, page).getData(value: FlickrSearch.self) { results in
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

//        loadModel(testCase: 1, isError: true)
//        private func loadModel(testCase: Int, isError: Bool) {
//            
//            let fm = FileManager.default
//            let resultsTuple = fm.loadPhotoInfoTestFile(for: testCase, isError: isError)
//            
//            if isError {
//                
//                // error model
//                if let model = resultsTuple.error {
//                    
//                    print("model - \(type(of: model)):", model)
//                }
//            }
//            else {
//                
//                // live model
//                if let model = resultsTuple.model {
//                    
//                    print("model - \(type(of: model)):", model)
//                    
//                    // display photo from model
//                    imageView.load(from: model)
//                }
//            }
        
//        let fm = FileManager.default
//        let resultsTuple = fm.loadPhotoInfoTestFile(for: 1, isError: false)
//        if let model = resultsTuple.model {
//
//            //self.model = model
//            let viewModel = FlickrPhotoVM(model: model)
//            let vc = PhotoInfoViewController(viewModel: viewModel)
//            navigationController?.pushViewController(vc, animated: true)
//
//        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
