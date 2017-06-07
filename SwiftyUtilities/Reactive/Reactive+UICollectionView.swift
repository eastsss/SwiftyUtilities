//
//  Reactive+UICollectionView.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UICollectionView {
    public var batchUpdate: BindingTarget<(insertions: [Int], modifications: [Int], deletions: [Int])> {
        return makeBindingTarget { base, update in
            base.performBatchUpdates({
                base.insertItems(at: update.insertions.indexPaths())
                base.reloadItems(at: update.modifications.indexPaths())
                base.deleteItems(at: update.deletions.indexPaths())
            }, completion: nil)
        }
    }
    
    public var reloadFirstSection: BindingTarget<()> {
        return makeBindingTarget { base, _ in
            if base.window == nil {
                base.reloadSections(IndexSet(integer: 0))
            } else {
                base.reloadData()
            }
        }
    }
}
