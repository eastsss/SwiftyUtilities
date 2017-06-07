//
//  RawRepresentable+Decoding.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Argo

extension RawRepresentable where Self: Decodable, Self.RawValue == String {
    public static func decodedRawRepresentable<D: Decodable>(from json: JSON, descriptionId: String = "enum") -> Decoded<D>
        where
        D: RawRepresentable,
        D.DecodedType == D,
        D.RawValue == String {
            
            guard case .string(let apiString) = json else {
                return .typeMismatch(expected: "String", actual: json)
            }
            
            let representable = D(rawValue: apiString)
            if let decoded = representable {
                return pure(decoded)
            } else {
                return .customError("Unexpected \(descriptionId) value \(apiString)")
            }
    }
}
