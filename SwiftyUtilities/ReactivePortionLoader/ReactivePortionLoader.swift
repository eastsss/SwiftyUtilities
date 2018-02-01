//
//  ReactivePortionLoader.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Moya
import ReactiveSwift
import Result

public protocol Portion: Decodable {
    associatedtype Item: Decodable
    
    var items: [Item] { get }
    var totalCount: Int { get }
}

public protocol ReactivePortionLoaderDelegate: class {
    func requestToken(forLoaderIdentifier identifier: String, offset: Int, limit: Int) -> TargetType
    func handle(error: Swift.Error)
}

public class ReactivePortionLoader<P: Portion, T: TargetType> {
    public typealias BatchUpdate = (insertions: [Int], modifications: [Int], deletions: [Int])
    public typealias Modification = (P.Item) -> P.Item
    public typealias Predicate = (P.Item) -> Bool
    public typealias DidLoadPortionCompletion = (_ offset: Int, _ limit: Int) -> Void
    
    public let identifier: String
    
    public weak var delegate: ReactivePortionLoaderDelegate?
    public var didLoadPortion: DidLoadPortionCompletion?
    
    // MARK: Reactive properties
    public var reloadFromStart: BindingTarget<()> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] in
            self?.loadInitialPortion()
        })
    }
    
    public var isNoResultsViewHidden: Property<Bool> {
        return Property(_isNoResultsViewHidden)
    }
    
    public var loading: Property<Bool> {
        return Property(_loading)
    }
    
    // MARK: Signals
    public let reload: Signal<(), NoError>
    public let batchUpdate: Signal<BatchUpdate, NoError>
    
    // MARK: Private reactive properties
    private let _isNoResultsViewHidden: MutableProperty<Bool> = MutableProperty(true)
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    private let (lifetime, token) = Lifetime.make()
    
    // MARK: Observers
    private let reloadObserver: Signal<(), NoError>.Observer
    private let batchUpdateObserver: Signal<BatchUpdate, NoError>.Observer
    
    // MARK: Network request related properties
    private let dataProvider: MoyaProvider<T>
    private let jsonDecoder: JSONDecoder
    private let portionSize: Int
    private var currentRequestDisposable: Disposable?
    
    // MARK: Data
    private var items: [P.Item] = []
    public private(set) var expectedTotalCount: Int = 0
    
    public init(dataProvider: MoyaProvider<T> = MoyaProvider<T>(),
                jsonDecoder: JSONDecoder = JSONDecoder(),
                portionSize: Int = 20,
                identifier: String? = nil) {
        self.dataProvider = dataProvider
        self.jsonDecoder = jsonDecoder
        self.portionSize = portionSize
        if let userDefinedIdentifier = identifier {
            self.identifier = userDefinedIdentifier
        } else {
            self.identifier = "\(type(of: self))"
        }
        
        (reload, reloadObserver) = Signal<(), NoError>.pipe()
        (batchUpdate, batchUpdateObserver) = Signal<BatchUpdate, NoError>.pipe()
    }
    
    deinit {
        currentRequestDisposable?.dispose()
    }
    
    public func loadInitialPortion() {
        loadItems(offset: 0, limit: portionSize)
    }
    
    public func loadNext() {
        if items.isEmpty {
            loadItems(offset: 0, limit: portionSize)
        } else {
            let loaded = items.count
            
            guard loaded < expectedTotalCount else {
                return
            }
            
            let remaining = expectedTotalCount - loaded
            let limit = (remaining < portionSize) ? remaining : portionSize
            
            loadItems(offset: loaded, limit: limit)
        }
    }
}

// MARK: Read items
extension ReactivePortionLoader {
    public func item(at index: Int) -> P.Item? {
        guard 0..<items.count ~= index else {
            return nil
        }
        
        return items[index]
    }
    
    public var itemsCount: Int {
        return items.count
    }
    
    public var allItems: [P.Item] {
        return items
    }
}

// MARK: Modify items
extension ReactivePortionLoader {
    public func modifyItems(with modification: Modification, where predicate: Predicate) {
        let indexes = items.indexes(where: predicate)
        
        for index in indexes {
            items[index] = modification(items[index])
        }
        
        if !indexes.isEmpty {
            batchUpdateObserver.send(value: ([], indexes, []))
        }
    }
    
    public func deleteItems(where predicate: Predicate) {
        let indexes = items.indexes(where: predicate)
        
        items = items.filter { !predicate($0) }
        
        if !indexes.isEmpty {
            batchUpdateObserver.send(value: ([], [], indexes))
        }
    }
    
    public func deleteAll() {
        deleteItems(where: { _ in true })
    }
}

// MARK: Portion loading
private extension ReactivePortionLoader {
    func loadItems(offset: Int, limit: Int) {
        if let existingRequest = currentRequestDisposable, !existingRequest.isDisposed {
            existingRequest.dispose()
        }
        
        guard let token = delegate?.requestToken(forLoaderIdentifier: identifier, offset: offset, limit: limit) as? T else {
            fatalError("ReactivePortionLoader delegate should return correct instance in requestToken(forLoaderIdentifier:offset:limit)")
        }
        
        currentRequestDisposable = dataProvider.reactive
            .request(token)
            .observe(on: UIScheduler())
            .filterSuccessfulStatusCodes()
            .map(P.self, using: jsonDecoder)
            .on(starting: { [weak self] in
                self?._loading.value = true
                self?._isNoResultsViewHidden.value = true
            })
            .on(value: { [weak self] portion in
                guard let strongSelf = self else {
                    return
                }
                
                if offset == 0 {
                    strongSelf.items = portion.items
                    strongSelf.reloadObserver.send(value: ())
                    strongSelf._isNoResultsViewHidden.value = !portion.items.isEmpty
                } else {
                    let newIndexes = (0..<portion.items.count).map({ $0 + strongSelf.items.count })
                    
                    strongSelf.items.append(contentsOf: portion.items)
                    
                    if !newIndexes.isEmpty {
                        strongSelf.batchUpdateObserver.send(value: (newIndexes, [], []))
                    }
                }
                
                strongSelf.expectedTotalCount = portion.totalCount
                strongSelf._loading.value = false
                strongSelf.didLoadPortion?(offset, limit)
            })
            .on(failed: { [weak self] error in
                if offset == 0 {
                    self?._isNoResultsViewHidden.value = false
                }
                self?.delegate?.handle(error: error)
            })
            .on(event: { [weak self] event in
                switch event {
                case .interrupted, .failed:
                    self?._loading.value = false
                default:
                    return
                }
            })
            .start()
    }
}
