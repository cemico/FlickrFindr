//
//  UIViewExt.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/24/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

extension UIView {
    
    // very simple alpha-animated blinking
    func blinkOn(duration: TimeInterval = 0.75,
                 delay: TimeInterval = 0,
                 lowAlpha: CGFloat = 0.5) {
        
        self.alpha = lowAlpha
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: [.curveLinear, .repeat, .autoreverse],
                       animations: {self.alpha = 1.0},
                       completion: nil)
    }
    
    func blinkOff() {
        
        // stop blink
        layer.removeAllAnimations()
    }
    
    func fadeHide(duration: TimeInterval = 0.4, completionHandler: ((Bool) -> Void)? = nil) {
        
        let oldAlpha = alpha
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: [],
                       animations: {self.alpha = 0},
                       completion: { [weak self] finished in
            
            // faded out, now hide
            self?.isHidden = true
                        
            // restore old alpha to not be disruptive
            self?.alpha = oldAlpha
                        
            // chain completions
            completionHandler?(finished)
        })
    }
}

