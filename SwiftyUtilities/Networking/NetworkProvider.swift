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
    var sampleData: Data {
        return Data()
    }
    
    var additionalHeaders: [String: String] {
        return [:]
    }
}

open class NetworkProvider<Target>: ReactiveSwiftMoyaProvider<Target> where Target: NetworkTarget {
    public init() {
        super.init(
            endpointClosure: NetworkProvider.customEndpointMapping,
            requestClosure: MoyaProvider.defaultRequestMapping,
            stubClosure: MoyaProvider.neverStub,
            manager: MoyaProvider<Target>.defaultAlamofireManager(),
            plugins: [],
            stubScheduler: nil,
            trackInflights: false
        )
    }
    
    public func req(_ target: Target) -> SignalProducer<Response, MoyaError> {
        return request(target).filterSuccessfulStatusCodes().observe(on: UIScheduler())
    }
    
    private final class func customEndpointMapping<T>(target: T) -> Endpoint<T> where T: NetworkTarget {
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
