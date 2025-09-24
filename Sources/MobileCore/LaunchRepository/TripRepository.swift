//
//  TripRepository.swift
//  MobileCore
//
//  Created by pravin tate on 23/09/25.
//
import MobileCoreAPI_Generated
import Foundation
import Combine
import Apollo

protocol TripRepository {
    /// Starts listening for booked trips updates
    func observeTripBooked(
        onUpdate: @escaping (Int?) -> Void
    ) -> Apollo.Cancellable?
}

struct TripRepositoryImpl: TripRepository {
    private let network: GraphQLNetwork

    init(networkFactory: ApolloNetworkFactory = ApolloNetworkFactoryImpl(),
         configurationProvider: ApolloConfigurationProvider = DefaultApolloConfigurationProvider()) {
        self.network = networkFactory.makeNetwork(configurationProvider: configurationProvider)
    }

    func observeTripBooked(
        onUpdate: @escaping (Int?) -> Void
    ) -> Apollo.Cancellable? {
        let subscription = TripBookedSubscription()

        if let cancellable = try? network.subscribe(subscription: subscription, resultHandler: { result in
            switch result {
            case .success(let graphQLResult):
                if let booked = graphQLResult.data?.tripsBooked {
                    onUpdate(booked)
                } else {
                    onUpdate(nil)
                }
            case .failure(let error):
                print("TripBooked subscription error: \(error)")
                onUpdate(nil)
            }
        }) {
            return cancellable
        }
        return nil
    }
}
