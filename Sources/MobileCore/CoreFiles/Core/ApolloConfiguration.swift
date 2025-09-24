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

protocol ApolloConfigurationProvider {
    var configuration: ApolloConfiguration { get }
}
class DefaultApolloConfigurationProvider: ApolloConfigurationProvider {
    let tokenProvider: TokenConfiguration
    let ldConfig: LDConfiguration

    var configuration: any ApolloConfiguration {
        makeConfiguration()
    }

    init(tokenProvider: TokenConfiguration = TokenConfiguration.shared,
         ldConfig: LDConfiguration = LDConfiguration()) {
        self.tokenProvider = tokenProvider
        self.ldConfig = ldConfig
    }

    func makeConfiguration() -> ApolloConfiguration {
        let tokenProvider = self.tokenProvider
        return DefaultApolloConfiguration(
            baseURLString: getBaseURLString(),
            webSocketURLString: getWebSocketURLString()
        ) { tokenProvider.getAuthorizationToken() }
    }

    func getBaseURLString() -> String {
        ldConfig.getBaseURL()
    }

    func getWebSocketURLString() -> String? {
        ldConfig.getWebSocketURL()
    }
}

class LDConfiguration {
    func getBaseURL() -> String {
        "https://apollo-fullstack-tutorial.herokuapp.com/graphql"
    }
    func getWebSocketURL() -> String? {
        "wss://apollo-fullstack-tutorial.herokuapp.com/graphql"
    }
}

final class TokenConfiguration {
    static let shared = TokenConfiguration()
    private var token = "dGF0ZS5wcmF2aW5AZ21haWwuY29t"
    var index = 0
    func getAuthorizationToken() -> String? {
        index += 1
        print("token updated here \(index)")
        return token
    }

    func setAuthorizationToken(_ value: String) {
        self.token = value
    }
}
