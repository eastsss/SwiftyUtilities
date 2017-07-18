//
//  AppUtilities.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Foundation

public class AppUtilities {
    public static var appVersion: String {
        // swiftlint:disable:next force_cast
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    public static var appLocalizationIdentifier: String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    public static var appLocale: Locale {
        return Locale(identifier: appLocalizationIdentifier)
    }
}
