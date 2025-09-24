//
//  LaunchRepository 2.swift
//  MobileCore
//
//  Created by pravin tate on 23/09/25.
//

import MobileCoreAPI_Generated

protocol LaunchRepository {
    func fetchLaunches() async throws -> [LaunchDomain]
}

struct LaunchRepositoryImpl: LaunchRepository {
    private let network: GraphQLNetwork

    init(networkFactory: ApolloNetworkFactory = ApolloNetworkFactoryImpl()) {
        self.network = networkFactory.makeNetwork()
    }

    func fetchLaunches() async throws -> [LaunchDomain] {
        let result = try await network.fetch(query: LaunchListQuery(), cachePolicy: .fetchIgnoringCacheData)
        return result.launches.toDomain()
    }
}
