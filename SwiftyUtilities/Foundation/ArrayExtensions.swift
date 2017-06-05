//
//  ArrayExtensions.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 02/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Foundation

extension Array {
    public func elements(at indexes: [Index]) -> [Element] {
        return enumerated().filter({ indexes.contains($0.offset) }).map({ $0.element })
    }
    
    public func indexes(where predicate: (Element) -> Bool) -> [Index] {
        return enumerated().filter({ predicate($0.element) }).map({ $0.offset })
    }
}

extension Array where Element == Int {
    public func indexPaths(section: Int = 0) -> [IndexPath] {
        return map({ IndexPath(row: $0, section: section) })
    }
}

extension Array where Element: Equatable {
    public var uniq: [Element] {
        return reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }
}
