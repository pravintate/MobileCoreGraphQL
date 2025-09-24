//
//  ApolloNetworkFactory.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//


protocol ApolloNetworkFactory {
    func makeNetwork() -> GraphQLNetwork
}

struct ApolloNetworkFactoryImpl: ApolloNetworkFactory {
    let configurationProvider: ApolloConfigurationProvider
    init(configurationProvider: ApolloConfigurationProvider = DefaultApolloConfigurationProvider()) {
        self.configurationProvider = configurationProvider
    }

    func makeNetwork() -> GraphQLNetwork {
        return ApolloNetworkImpl(configuration: configurationProvider.configuration)
    }
}
