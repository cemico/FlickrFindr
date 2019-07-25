//
//  IntExt.swift
//  Flickr Findr
//
//  Created by David Rogers on 7/24/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

extension Int {
    
    var shortFormat: String {
        
        // sanity and lower limits
        guard self >= 999 else { return "\(self)"}
        
        // note: k = thousand, m = million, b = billion
        let thousand = 1000
        let million = thousand * thousand
        let billion = thousand * million
        let selfF = Float(self)

        if self >= billion {
            
            // billions+
            let selfB = Float(billion)
            let short = selfF / selfB
            
            // perform rounding
            let shortRound = (short * 1000).rounded() / 1000
            
            // billion to 3 decimals
            return String(format: "%0.3fb", shortRound)
        }
        else if self >= million {
            
            // millions
            let selfM = Float(million)
            let short = selfF / selfM

            // perform rounding
            let shortRound = (short * 100).rounded() / 100
            
            // million to 2 decimals
            return String(format: "%0.2fm", shortRound)
        }
        else {
            
            // thousands
            let selfK = Float(thousand)
            let short = selfF / selfK
            
            // perform rounding
            let shortRound = (short * 10).rounded() / 10
            
            // thousands to 1 decimals
            return String(format: "%0.1fk", shortRound)
        }
    }
}
