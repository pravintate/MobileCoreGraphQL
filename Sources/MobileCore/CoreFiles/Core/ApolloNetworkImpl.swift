//
//  ApolloNetworkImpl.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//
import ApolloAPI
import Apollo

enum ApolloError: Error {
    case graphQLErrors([GraphQLError])
    case noData
    case transportError(Error)
    case inValidBaseURL(String)
    case invalidSocketURL(String?)
}

final class ApolloNetworkImpl: GraphQLNetwork {
    private let configuration: ApolloConfiguration
    private let clientProvider: ApolloClientProvider

    init(configuration: ApolloConfiguration,
         clientProvider: ApolloClientProvider = DefaultApolloClientProvider.shared) {
        self.configuration = configuration
        self.clientProvider = clientProvider
    }

    private func getClient() throws -> ApolloClient {
        let client = try clientProvider.makeSplitClient(configuration: configuration)
        return client
    }

    func fetch<Query: GraphQLQuery>(query: Query,
                                    cachePolicy: CachePolicy = .fetchIgnoringCacheData) async throws -> Query.Data {
        let client = try getClient()
        return try await withCheckedThrowingContinuation { continuation in
            client.fetch(query: query, cachePolicy: cachePolicy) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors, !errors.isEmpty {
                        continuation.resume(throwing: ApolloError.graphQLErrors(errors))
                        return
                    }
                    if let data = graphQLResult.data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: ApolloError.noData)
                    }
                case .failure(let error):
                    continuation.resume(throwing: ApolloError.transportError(error))
                }
            }
        }
    }

    func perform<Mutation: GraphQLMutation>(mutation: Mutation)
    async throws -> Mutation.Data {
        let client = try getClient()
        return try await withCheckedThrowingContinuation { continuation in
            client.perform(mutation: mutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors, !errors.isEmpty {
                        continuation.resume(throwing: ApolloError.graphQLErrors(errors))
                        return
                    }
                    if let data = graphQLResult.data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: ApolloError.noData)
                    }
                case .failure(let error):
                    continuation.resume(throwing: ApolloError.transportError(error))
                }
            }
        }
    }

    func subscribe<Subscription: GraphQLSubscription>(
        subscription: Subscription) async throws -> AsyncThrowingStream<GraphQLResult<Subscription.Data>, Error> {
            let client = try getClient()
            clientProvider.updateAuthorizationHeader(with: configuration.authorizationTokenProvider())
            return AsyncThrowingStream { continuation in
                let cancellable = client.subscribe(subscription: subscription) { result in
                    switch result {
                    case .success(let graphQLResult):
                        continuation.yield(graphQLResult)
                    case .failure(let error):
                        continuation.finish(throwing: error)
                        return
                    }
                }
                // When the stream is cancelled, cancel the subscription
                continuation.onTermination = { @Sendable _ in
                    cancellable.cancel()
                }
            }
        }
}
