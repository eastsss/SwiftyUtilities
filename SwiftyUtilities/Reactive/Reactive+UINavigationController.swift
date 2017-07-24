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
    public func pushViewController(animated: Bool) -> BindingTarget<UIViewController> {
        return makeBindingTarget { base, controller in
            let pushBlock = { [weak base] in
                _ = base?.pushViewController(controller, animated: animated)
            }
            
            if base.presentedViewController != nil {
                base.dismiss(animated: animated, completion: pushBlock)
            } else {
                pushBlock()
            }
        }
    }
    
    public func popViewController(animated: Bool) -> BindingTarget<()> {
        return makeBindingTarget { base, _ in base.popViewController(animated: true) }
    }
}
