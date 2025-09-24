//
//  BookTripRepository.swift
//  MobileCore
//
//  Created by pravin tate on 23/09/25.
//
import MobileCoreAPI_Generated

protocol BookTripRepository {
    func bookTrip(trips: [String]) async throws -> String
}

struct BookTripRepositoryImpl: BookTripRepository {
    private let network: GraphQLNetwork

    init(networkFactory: ApolloNetworkFactory = ApolloNetworkFactoryImpl(),
         configurationProvider: ApolloConfigurationProvider = DefaultApolloConfigurationProvider()) {
        self.network = networkFactory.makeNetwork(configurationProvider: configurationProvider)
    }

    func bookTrip(trips: [String]) async throws -> String {
        let result = try await network.perform(mutation: BookTripMutation(ids: trips))
        if let message = result.bookTrips.message {
            return message
        }
        throw ApolloError.noData
    }
}
