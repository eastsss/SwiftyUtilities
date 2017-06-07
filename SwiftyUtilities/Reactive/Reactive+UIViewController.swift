//
//  Reactive+UIViewController.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UIViewController {
    public func presentViewController(animated: Bool) -> BindingTarget<UIViewController> {
        return makeBindingTarget { $0.present($1, animated: animated) }
    }
    
    public func dismissViewController(animated: Bool) -> BindingTarget<()> {
        return makeBindingTarget { base, _ in base.dismiss(animated: true) }
    }
}
