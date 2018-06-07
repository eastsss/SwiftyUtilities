//
//  URL+Coding.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Argo
import Ogra

extension URL: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<URL> {
        guard case .string(let urlString) = json else {
            return .typeMismatch(expected: "String", actual: json)
        }
        
        guard let url = URL(string: urlString) else {
            return .customError("Incorrect URL value \(urlString)")
        }
        
        return pure(url)
    }
}

extension URL: Ogra.Encodable {
    public func encode() -> JSON {
        return JSON.string(absoluteString)
    }
}
