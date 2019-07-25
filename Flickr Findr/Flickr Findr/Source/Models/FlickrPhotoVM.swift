//
//  FlickrPhotoVM.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/22/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

struct FlickrPhotoVM {
    
    // injected model, note: using default struct init
    let model: FlickrPhoto
    
    let title = "Photo Info"
    
    // expose functionality for view
    enum PhotoSize: String, CaseIterable {
        
        /* The letter suffixes are as follows:
         s    small square 75x75
         q    large square 150x150
         t    thumbnail, 100 on longest side
         m    small, 240 on longest side
         n    small, 320 on longest side
         -    medium, 500 on longest side
         z    medium 640, 640 on longest side
         c    medium 800, 800 on longest side†
         b    large, 1024 on longest side*
         h    large 1600, 1600 on longest side†
         k    large 2048, 2048 on longest side†
         o    original image, either a jpg, gif or png, depending on source format
         */
        
        // note: docs specifically say set is [mstzb], thus matching uncommented entries
        //       I tested w/ a few of the others, sometimes there, sometimes now
        case smallSquare75x75
//        case largeSquare150x150
        case thumbnail100
        case small250
//        case small320
//        case medium500
        case medium640
//        case medium800
        case large1024
//        case large1600
//        case large2048
//        case original
        
        var format: (letter: String, size: Int) {
            
            switch self {
                
            case .smallSquare75x75:     return (letter: "s", size: 75)
//            case .largeSquare150x150:   return (letter: "q", size: 150)
            case .thumbnail100:         return (letter: "t", size: 100)
            case .small250:             return (letter: "m", size: 250)
//            case .small320:             return (letter: "n", size: 320)
//            case .medium500:            return (letter: "-", size: 500)
            case .medium640:            return (letter: "z", size: 640)
//            case .medium800:            return (letter: "c", size: 800)
            case .large1024:            return (letter: "b", size: 1024)
//            case .large1600:            return (letter: "h", size: 1600)
//            case .large2048:            return (letter: "k", size: 2048)
//            case .original:             return (letter: "o", size: -1)
            }
        }
        
        // dynamic urls, returns smallest value which is >= requested size
        // so dynamic content size on different devices can have optimal
        // thumbnails and images
        static func format(from size: Int) -> PhotoSize {
            
            // small working set: 2xO(n)...or just O(n)
            // nice use of chaining higher-order functions
            let orderedSet = PhotoSize.allCases
                .filter({ $0.format.size >= size })
                .sorted(by: { $0.format.size < $1.format.size })
            
            if let format = orderedSet.first {
                
                return format
            }
            else {
                
                return PhotoSize.large1024
            }
        }
    }
    
    func getImageURL(for size: Int) -> String {
        
        let format = PhotoSize.format(from: size)
        return getURL(size: format)
    }
    
    private func getURL(size: PhotoSize) -> String {
        
        // docs: https://www.flickr.com/services/api/misc.urls.html
        // format: https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
        let base = "https://farm\(model.farm).staticflickr.com/"
        let path = "\(model.server)/"
        let filename = "\(model.id)_\(model.secret)_\(size.format.letter).jpg"
        return base + path + filename
    }
}
