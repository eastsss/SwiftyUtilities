//
//  StringExtensions.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 25/07/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Foundation

extension String {
    public func inserting(separator: String, afterEvery amount: Int) -> String {
        var result: String = ""
        
        enumerated().forEach { index, character in
            if index % amount == 0 && index > 0 {
                result += separator
            }
            
            result.append(character)
        }
        
        return result
    }
}
