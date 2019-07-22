//
//  BundleExt.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

extension Bundle {

    enum InfoPlistKeys: String {

        // root dictionary key in info.plist
        case companyRoot = "BleacherReport"

        // child keys to company
        enum CompanyChildKeys: String {

            case flickrApiKey = "FLICKR_API_KEY"
            case flickrApiUrl = "FLICKR_API_URL"

            var value: String {

                return InfoPlistKeys.companyStringInfoValue(for: self)
            }
        }

        // get our customize area of info.plist, which uses the *old*
        // technique of User Define Settings allowing different values
        // for different schemes, allowing different values for say
        // Debug and Release, and any custom schemes.  the same can
        // be setup using xcconfig files, much like Pods does to
        // replace / override values in project settings.
        static var companyDict: [String: Any]?  {

            guard let infoDict = main.infoDictionary else { return nil }
            return infoDict[Bundle.InfoPlistKeys.companyRoot.rawValue] as? [String: Any]
        }

        // api - accessors, convenienct top level
        static func companyStringInfoValue(for key: InfoPlistKeys.CompanyChildKeys) -> String {

            guard let dict = companyDict else { return "" }
            guard let value = dict[key.rawValue] as? String else { return "" }
            return value
        }
    }
}
