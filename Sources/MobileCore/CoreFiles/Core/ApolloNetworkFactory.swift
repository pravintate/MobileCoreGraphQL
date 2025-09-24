//
//  ApolloNetworkFactory.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//


protocol ApolloNetworkFactory {
    func makeNetwork(configurationProvider: ApolloConfigurationProvider) -> GraphQLNetwork
}

struct ApolloNetworkFactoryImpl: ApolloNetworkFactory {
    func makeNetwork(configurationProvider: ApolloConfigurationProvider = DefaultApolloConfigurationProvider()) -> GraphQLNetwork {
        return ApolloNetworkImpl(configuration: configurationProvider.configuration)
    }
}
