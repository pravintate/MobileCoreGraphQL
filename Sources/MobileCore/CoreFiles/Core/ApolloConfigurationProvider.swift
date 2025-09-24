//
//  ApolloConfigurationProvider.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//


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