//
//  GraphQLNetwork.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//

import ApolloAPI
import Apollo

public protocol GraphQLNetwork {
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy
    ) async throws -> Query.Data

    func perform<Mutation: GraphQLMutation>(
        mutation: Mutation
    ) async throws -> Mutation.Data

    func subscribe<Subscription: GraphQLSubscription>(
        subscription: Subscription,
        resultHandler: @escaping (Result<GraphQLResult<Subscription.Data>, Error>) -> Void
    ) throws -> any Apollo.Cancellable
}
