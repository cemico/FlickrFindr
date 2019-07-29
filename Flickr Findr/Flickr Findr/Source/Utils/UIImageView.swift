//
//  UIImageView.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/23/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

// local caches
// could write a custom class to encapsulate this functionality
// but in the essence of time for the take home assignment ... put here
// note: NSCache is auto-sensitive to low memory conditions
//       NSCache does not copy the element, unlike a rolled dictionary cache

// note; using deferred init to couple parameter settings before available to caller

// limited by count (and potentially other factors),
// would think a large number of smaller more
// frequently images should suffice - should be fine tunned via
// testing, or left unbound - used as another cache example
fileprivate let thumbCache: NSCache<NSString, UIImage> = {
    
    let boundCache = NSCache<NSString, UIImage>()
    
    // arbitrary "large" number of icon caching to account
    // for lots of scrolling on similar search filter(s)
    boundCache.countLimit = 1000
    return boundCache
}()

// limited by size cache for larger images
fileprivate var imageCache: NSCache<NSString, UIImage> = {
    
    let boundCache = NSCache<NSString, UIImage>()
    
    // bigger pics grow quickly, limit to total cache size of 20mb
    // if request comes in which would exceed limit, cache will
    // jettison earlier saved items until there is room
    let mb20 = 20 * 1000 * 1000
    boundCache.totalCostLimit = mb20
    return boundCache
}()

fileprivate var requestCache: [String: String] = [:]

extension UIImageView {
    
    private enum Constants: String {
        
        case downloadFailed = "image-download-failed"
        case unableToLoad = "unable-to-load-image"
        case loading = "loading-white-text"
        
        var image: String { return rawValue }
    }

    // String = imageId, Bool = success
    typealias ImageLoadResultsType = ((String, Bool) -> Void)

    // exposed api
    func load(from model: FlickrPhoto,
              loadingImage: String = Constants.loading.image,
              errorImage: String = Constants.downloadFailed.image,
              isThumb: Bool = true,
              completionHandler: @escaping ImageLoadResultsType) {

        // convenience mapper to url load below
        let size = self.bounds.width.intValue
        let vm = FlickrPhotoVM(model: model)
        self.load(urlPath: vm.getImageURL(for: size),
                  imageId: model.id,
                  loadingImage: loadingImage,
                  errorImage: errorImage,
                  isThumb: isThumb,
                  completionHandler: completionHandler)
    }

    func imagePrepareForReuse() {

        // done with cell - reset cache for this item
        setCacheItem(value: nil)
    }
    
    private func load(urlPath: String,
                      imageId: String,
                      loadingImage: String = Constants.loading.image,
                      errorImage: String = Constants.unableToLoad.image,
                      isThumb: Bool = true,
                      completionHandler: ImageLoadResultsType?) {

        // example of defining closure, in this case to reduce a repeated task
        let updateOnMainQueue = { (image: UIImage?) in
            
            // fastest path: immediate or async
            if Thread.current.isMainThread {
                
                self.image = image
            }
            else {
                
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            }
        }
        
        // check our cache
        let cache = (isThumb ? thumbCache : imageCache)
        let key = urlPath as NSString
        if let cachedImage = cache.object(forKey: key) {
            
            // yes - update, done
            updateOnMainQueue(cachedImage)
            print("c", terminator: "")
            return
        }

        // get location
        guard let imageURL = URL(string: urlPath) else {
            
            // show error image
            updateOnMainQueue(UIImage(named: errorImage))
            return
        }
        
        // loading image
        // note: I usually like to code up a slight delay before
        //       showing a loading indicator, maybe 1-2s, allowing
        //       most photos to load/show w/o the flash of the
        //       loading indicator, yet having it on those w/
        //       extended time.  here we always show.
        updateOnMainQueue(UIImage(named: loadingImage))
        
        // load
        load(url: imageURL,
             imageId: imageId,
             isThumb: isThumb,
             errorImage: errorImage) { (imageId, success) in

            // chain
            completionHandler?(imageId, success)
        }
    }
    
    private func load(url: URL,
                      imageId: String,
                      isThumb: Bool,
                      errorImage: String,
                      completionHandler: ImageLoadResultsType?) {
        
        // track current request so we know to only update to the latest request
        // ex) usual load request, then cell is reused, and a new
        //     load request (2nd) on the reused cell before first returns.
        //     in this scenario, if the first request finishes first, it'd
        //     fail the check that the lastUrlRequest matches, as this
        //     would be set to latest / 2nd value.  same is true if first
        //     request comes in after the second request.
        
        // use object memory address as key
        setCacheItem(value: url.absoluteString)

        // note: with more time, would have likely rolled the image requests
        //       into a DispatchGroup to have better control over when
        //       batches of requests are done, priority, and ability to
        //       cancel requests (say for bigger images)
        
        // background async load
        DispatchQueue.global().async { [weak self] in
            
            // pull the data and create image
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                
                // always cache, note brindging string
                let cache = (isThumb ? thumbCache : imageCache)
                let key = url.absoluteString as NSString
                cache.setObject(image, forKey: key)
                
                // update on main queye async
                DispatchQueue.main.async {
                    
                    // have image - make sure the request hasn't changed
                    // from under us by multiple quick requests, as from
                    // a table or collection view
                    guard let strongSelf = self else { return }
                    
                    // extract the url of the last request
                    let requestKey = "\(Unmanaged.passUnretained(strongSelf).toOpaque())"
                    
                    // main queue is serial, no need to sync threads
                    let cachedRequestUrl = requestCache[requestKey, default: ""]
                    
                    // ensure expected results from potential cell reuse
                    if url.absoluteString == cachedRequestUrl {
                        
                        strongSelf.image = image
                        print("o", terminator: "")
                    }
                    else {
                        
                        print("skipped - cell reuse with multiple requests")
                    }
                    completionHandler?(imageId, true)
                }
            }
            else {
                
                // show error image
                DispatchQueue.main.mainInline {
                    
                    self?.image = UIImage(named: errorImage)
                }
                completionHandler?(imageId, false)
            }
        }
    }

    private func setCacheItem(value: String?) {

        // use object memory address as key
        NSLock().synchronized {

            let requestKey = "\(Unmanaged.passUnretained(self).toOpaque())"
            requestCache[requestKey] = value
            print("request queue size:", requestCache.count)
        }

    }
}
