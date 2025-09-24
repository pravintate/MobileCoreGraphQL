//
//  TripRepository.swift
//  MobileCore
//
//  Created by pravin tate on 23/09/25.
//
import MobileCoreAPI_Generated
import Foundation
import Apollo

protocol TripRepository {
    func subscribe() async throws -> AsyncThrowingStream<GraphQLResult<TripBookedSubscription.Data>, Error>
}

struct TripRepositoryImpl: TripRepository {
    private let network: GraphQLNetwork
    typealias SubscriptionResult = GraphQLResult<TripBookedSubscription.Data>

    init(networkFactory: ApolloNetworkFactory = ApolloNetworkFactoryImpl()) {
        self.network = networkFactory.makeNetwork()
    }

    func subscribe() async throws -> AsyncThrowingStream<SubscriptionResult, Error> {
        return try await network.subscribe(subscription: TripBookedSubscription())
    }
}
