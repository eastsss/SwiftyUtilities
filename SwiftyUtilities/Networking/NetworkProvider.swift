//
//  NetworkProvider.swift
//  SwiftyUtilities
//
//  Created by Anatoliy Radchenko on 07/06/2017.
//  Copyright © 2017 SwiftyUtilities. All rights reserved.
//

import Moya
import ReactiveSwift

public protocol NetworkTarget: TargetType {
    var additionalHeaders: [String: String] { get }
}

public extension NetworkTarget {
    var task: Task {
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var additionalHeaders: [String: String] {
        return [:]
    }
}

open class NetworkProvider<Target>: MoyaProvider<Target> where Target: NetworkTarget {
    
    public init() {
        super.init(
            endpointClosure: NetworkProvider.customEndpointMapping,
            requestClosure: NetworkProvider.defaultRequestMapping,
            stubClosure: NetworkProvider.neverStub,
            manager: NetworkProvider<Target>.defaultAlamofireManager(),
            plugins: [],
            trackInflights: false
        )
    }
    
    public func req(_ target: Target) -> SignalProducer<Response, MoyaError> {
        return self.reactive.request(target).filterSuccessfulStatusCodes().observe(on: UIScheduler())
    }
    
    private final class func customEndpointMapping<T: NetworkTarget>(for target: T) -> Endpoint {
        let endpoint = MoyaProvider.defaultEndpointMapping(for: target)
            .adding(newHTTPHeaderFields: [
                "X-App-Version": AppUtilities.appVersion
            ])
        
        if !target.additionalHeaders.isEmpty {
            return endpoint.adding(newHTTPHeaderFields: target.additionalHeaders)
        } else {
            return endpoint
        }
    }
}
