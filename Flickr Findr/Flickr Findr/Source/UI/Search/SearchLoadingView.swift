//
//  SearchLoadingView.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/24/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import UIKit

class SearchLoadingView: UIView {

    // outlets
    @IBOutlet weak var messageLabel: UILabel!
    
    // properties
    private var blinkRequests = 0

    // lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        initLocal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // nib / storyboard route
        initLocal()
    }
    
    private func initLocal() {
        
        // spruce up must a bit, round both top corners
        clipsToBounds = true
        layer.cornerRadius = bounds.size.height / 2
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // api
    func blink(_ show: Bool, hideAfterStop: Bool = true) {
        
        guard show == isHidden && messageLabel != nil else { return }
        
        if show {
            
            // handle multiple on requests to match off
            blinkRequests += 1
            messageLabel.blinkOn()
            isHidden = false
        }
        else {
            
            blinkRequests -= 1
            messageLabel.blinkOff()
            if hideAfterStop && blinkRequests <= 0 {
                
                isHidden = true
                blinkRequests = 0
            }
        }
    }
}
