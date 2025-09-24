//
//  ApolloConfiguration.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//
public protocol ApolloConfiguration {
    var baseURLString: String { get }
    var webSocketURLString: String? { get }
    var authorizationTokenProvider: () -> String? { get }
}

public struct DefaultApolloConfiguration: ApolloConfiguration {
    public let baseURLString: String
    public let webSocketURLString: String?
    public let authorizationTokenProvider: () -> String?

    public init(baseURLString: String,
                webSocketURLString: String?,
                authorizationTokenProvider: @escaping () -> String?) {
        self.baseURLString = baseURLString
        self.webSocketURLString = webSocketURLString
        self.authorizationTokenProvider = authorizationTokenProvider
    }
}
