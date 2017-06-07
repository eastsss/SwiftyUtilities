//
//  CGSize+Decodable.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Argo
import Curry
import Runes

extension CGSize: Decodable {
    public static func decode(_ json: JSON) -> Decoded<CGSize> {
        //to make semantics more explicit we should add cast to Decoded<Double>,
        //otherwise compiler won't know which initializer of CGSize should be used
        return curry(CGSize.init)
            <^> (json <| "width") as Decoded<Double>
            <*> (json <| "height") as Decoded<Double>
    }
}
