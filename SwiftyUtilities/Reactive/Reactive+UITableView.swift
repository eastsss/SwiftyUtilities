//
//  Reactive+UITableView.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UITableView {
    func batchUpdate(animation: UITableViewRowAnimation) -> BindingTarget<(insertions: [Int], modifications: [Int], deletions: [Int])> {
        return makeBindingTarget { base, update in
            base.beginUpdates()
            base.insertRows(at: update.insertions.indexPaths(), with: animation)
            base.reloadRows(at: update.modifications.indexPaths(), with: animation)
            base.deleteRows(at: update.deletions.indexPaths(), with: animation)
            base.endUpdates()
        }
    }
}
