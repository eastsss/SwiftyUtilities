//
//  Reactive+UINavigationController.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UINavigationController {
    func pushViewController(animated: Bool) -> BindingTarget<UIViewController> {
        return makeBindingTarget { $0.pushViewController($1, animated: animated) }
    }
    
    func popViewController(animated: Bool) -> BindingTarget<()> {
        return makeBindingTarget { base, _ in base.popViewController(animated: true) }
    }
}
