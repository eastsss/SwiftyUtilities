//
//  KeyValueStoring.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Foundation

public protocol KeyValueStoring: class {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
    
    func bool(forKey defaultName: String) -> Bool
    func set(_ value: Bool, forKey defaultName: String)
    
    func integer(forKey defaultName: String) -> Int
    func set(_ value: Int, forKey defaultName: String)
    
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: KeyValueStoring {}
