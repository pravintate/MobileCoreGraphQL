//
//  ApolloNetworkFactory.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//
import Foundation
/*
protocol ApolloConfigurationProvider {
    func getBaseURL() throws -> URL
    func getWebSocketURL() throws -> URL
    func getAthurizationToken() -> String?
}

class DefaultConfigurationProviderImpl: ApolloConfigurationProvider {
    struct Constants {
        let baseURL = "https://apollo-fullstack-tutorial.herokuapp.com/graphql"
        let webSocketURL = "wss://apollo-fullstack-tutorial.herokuapp.com/graphql"
    }
    private let constants = Constants()

    func getBaseURL() throws -> URL {
        guard let baseURL = URL(string: constants.baseURL) else {
            throw ApolloNetowrkFactoryError.baseURLNotValid
        }
        return baseURL
    }
    func getWebSocketURL() throws -> URL {
        guard let baseURL = URL(string: constants.webSocketURL) else {
            throw ApolloNetowrkFactoryError.baseURLNotValid
        }
        return baseURL
    }
    func getAthurizationToken() -> String? {
        "dGF0ZS5wcmF2aW5AZ21haWwuY29t"
    }
}

protocol ApolloConfiguration {
    var baseURL: URL { get }
    var webSocketURL: URL { get }
    var authrizationTokenProvider: () -> String? { get }
}

struct DefaultApolloConfiguration: ApolloConfiguration {
    var baseURL: URL
    var webSocketURL: URL
    var authrizationTokenProvider: () -> String?
    
    let configurationProvider: ApolloConfigurationProvider

    init(configurationProvider: ApolloConfigurationProvider = DefaultConfigurationProviderImpl()) {
        self.configurationProvider = configurationProvider
        do {
            self.baseURL = try configurationProvider.getBaseURL()
            self.webSocketURL = try configurationProvider.getWebSocketURL()
            self.authrizationTokenProvider = { configurationProvider.getAthurizationToken() }
        } catch {
            debugPrint(error)
            fatalError(#file + ": " + #function + ": unable to initialize configuration")
        }
    }
}

protocol ApolloNetworkFactory {
    func makeApolloNetwork() -> GraphQLNetwork
}

final class ApolloNetworkFactoryImpl: ApolloNetworkFactory {
    static let shared: ApolloNetworkFactory = ApolloNetworkFactoryImpl()
    private var apolloNetwork: GraphQLNetwork?

    init() {
    }

    func makeNetwork(_ configurationProvider: ApolloConfigurationProvider = DefaultConfigurationProviderImpl(),
                     factory: ApolloClientProvider = DefaultApolloClientProviderImpl()) throws -> GraphQLNetwork {
        if apolloNetwork == nil {
            let configuration = DefaultApolloConfiguration(configurationProvider: configurationProvider)
            apolloNetwork = ApolloNetworkImpl(configuration, clientFactory: DefaultApolloClientProviderImpl())
        }
        guard let apolloNetwork = apolloNetwork else {
            throw ApolloNetowrkFactoryError.clientNotCreated
        }
        return apolloNetwork
    }

    func makeApolloNetwork() -> GraphQLNetwork {
        do {
            return try makeNetwork()
        } catch {
            fatalError("Apollo client not created")
        }
    }
}
enum ApolloNetowrkFactoryError: Error {
    case clientNotCreated
    case baseURLNotValid
    case webSocketURLNotValid
}
*/
