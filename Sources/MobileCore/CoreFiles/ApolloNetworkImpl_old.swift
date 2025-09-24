//
//  MobileCore.swift
//  MobileCore
//
//  Created by pravin tate on 22/09/25.
//
import MobileCoreAPI_Generated
import ApolloAPI
import Apollo
import Foundation
import ApolloWebSocket
/*
final class AuthorizationInterceptor: ApolloInterceptor {
    public var id: String = UUID().uuidString
    let tokenProvider: () -> String?

    init(tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
    }
    func interceptAsync<Operation>(
           chain: any RequestChain,
           request: HTTPRequest<Operation>,
           response: HTTPResponse<Operation>?,
           completion: @escaping (Result<GraphQLResult<Operation.Data>, any Error>) -> Void
       ) where Operation: GraphQLOperation {

           // Add token header
           if let token = tokenProvider() {
               request.addHeader(name: "Authorization", value: "\(token)")
           }

           if let requestObject = try? request.toURLRequest() {
               // Log the outgoing request
               print("➡️ GraphQL Request:")
               print("URL: \(String(describing: requestObject.url))")
               print("Headers: \(String(describing: requestObject.allHTTPHeaderFields))")
               if let body = requestObject.httpBody, let bodyString = String(data: body, encoding: .utf8) {
                   print("Body: \(bodyString)")
               }
           }

           // Proceed with the request
           chain.proceedAsync(request: request, response: response, interceptor: self) { result in
               // Log the response
               switch result {
               case .success(let graphQLResult):
                   print("✅ GraphQL Response:")
                   if let data = graphQLResult.data {
                       print("Data: \(data)")
                   }
                   if let errors = graphQLResult.errors {
                       print("GraphQL Errors: \(errors)")
                   }
               case .failure(let error):
                   print("❌ Network / Transport Error: \(error)")
               }

               // Call the original completion
               completion(result)
           }
       }
}

final class CustomInterceptorProvider: DefaultInterceptorProvider {
    let tokenProvider: () -> String?
    init(client: URLSessionClient, store: ApolloStore,
         tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
        super.init(client: client, store: store)
    }
    override func interceptors<Operation>(for operation: Operation) ->
    [any ApolloInterceptor] where Operation : GraphQLOperation {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(tokenProvider: tokenProvider), at: 0)
        return interceptors
    }
}


protocol ApolloClientProvider {
    func makeSplitClient(modal: ApolloConfiguration) -> ApolloClient
}

final class DefaultApolloClientProviderImpl: ApolloClientProvider {
    private var apolloClient: ApolloClient!
    private var webSocketTransport: WebSocketTransport?

    func getClient(_ modal: ApolloConfiguration) -> ApolloClient {
        webSocketTransport?.updateConnectingPayload(
            ["Authorization": modal.authrizationTokenProvider() ?? ""],
            reconnectIfConnected: true
          )
        return apolloClient
    }

    func makeSplitClient(modal: ApolloConfiguration) -> ApolloClient {
        let webSocket = WebSocket(url: modal.webSocketURL, protocol: .graphql_ws)
        webSocketTransport = WebSocketTransport(
            websocket: webSocket,
            store: ApolloStore(),
            config: .init(connectingPayload: ["Authorization": modal.authrizationTokenProvider() ?? ""])
        )

        let client = URLSessionClient()
        let store = ApolloStore(cache: InMemoryNormalizedCache())
        let interceptorProvider = CustomInterceptorProvider(client: client, store: store,
                                                            tokenProvider: modal.authrizationTokenProvider)

        let uploadTransport = RequestChainNetworkTransport(interceptorProvider: interceptorProvider,
                                                     endpointURL: modal.baseURL)
        guard let webSocketTransport = webSocketTransport else {
            fatalError("wesocket transport is nil")
        }
        let splitTransport = SplitNetworkTransport(uploadingNetworkTransport: uploadTransport,
                              webSocketNetworkTransport: webSocketTransport)
        apolloClient = ApolloClient(networkTransport: splitTransport, store: store)
        return apolloClient
    }
}


protocol GraphQLNetwork {
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy) async throws -> Query.Data

    func perform<Mutation: GraphQLMutation>(
            mutation: Mutation) async throws -> Mutation.Data

    func subscribe<Subscription: GraphQLSubscription>(
        subscription: Subscription,
        resultHandler: @escaping (Result<GraphQLResult<Subscription.Data>, Error>) -> Void
    ) -> Apollo.Cancellable
}



final class ApolloNetworkImpl: GraphQLNetwork {
    private let splitClient: ApolloClient

    init(_ modal: ApolloConfiguration,
         clientFactory: ApolloClientProvider) {
        self.splitClient = clientFactory.makeSplitClient(modal: modal)
    }

    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .fetchIgnoringCacheData
    ) async throws -> Query.Data {
        try await withCheckedThrowingContinuation { continuation in
            splitClient.fetch(query: query,
                         cachePolicy: cachePolicy) { result in
                switch result {
                case .success(let graphQLResult):
                    if let erros = graphQLResult.errors, !erros.isEmpty {
                        continuation.resume(throwing: ApolloError.graphQLErrors(erros))
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

    func perform<Mutation: GraphQLMutation>(
        mutation: Mutation
    ) async throws -> Mutation.Data {
        try await withCheckedThrowingContinuation { continuation in
            splitClient.perform(mutation: mutation) { result in
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

    // Subscription
    func subscribe<Subscription: GraphQLSubscription>(
        subscription: Subscription,
        resultHandler: @escaping (Result<GraphQLResult<Subscription.Data>, Error>) -> Void
    ) -> any Apollo.Cancellable {
        return splitClient.subscribe(subscription: subscription, resultHandler: resultHandler)
    }
}


enum ApolloError: Error {
    case graphQLErrors([GraphQLError])
    case noData
    case transportError(Error)
}
*/
