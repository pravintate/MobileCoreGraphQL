//
//  DefaultApolloClientProvider.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//
import Foundation
import ApolloAPI
import Apollo
import ApolloWebSocket
protocol ApolloClientProvider {
    func makeSplitClient(configuration: ApolloConfiguration) throws -> ApolloClient
    func updateAuthorizationHeader(with token: String?)
}
final class DefaultApolloClientProvider: ApolloClientProvider {
    static let shared = DefaultApolloClientProvider()
    private var client: ApolloClient?
    private var webSocketTransport: WebSocketTransport?
    private let authorizationKey = "Authorization"
    private init() {}

    func makeSplitClient(configuration: ApolloConfiguration) throws -> ApolloClient {
        if let client {
            return client
        }

        guard let baseURL = URL(string: configuration.baseURLString) else {
            throw ApolloError.inValidBaseURL(configuration.baseURLString)
        }
        guard let webSocketURLString = configuration.webSocketURLString,
              let webSocketURL = URL(string: webSocketURLString) else {
            throw ApolloError.invalidSocketURL(configuration.webSocketURLString)
        }

        // WebSocket transport
        let webSocket = WebSocket(url: webSocketURL, protocol: .graphql_ws)
        let localWebSocketTransport = WebSocketTransport(
            websocket: webSocket,
            store: ApolloStore(),
            config: .init(connectingPayload: [authorizationKey: configuration.authorizationTokenProvider() ?? ""])
        )
        self.webSocketTransport = localWebSocketTransport
        self.webSocketTransport?.delegate = self

        // HTTP transport
        let client = URLSessionClient()
        let store = ApolloStore(cache: InMemoryNormalizedCache())
        let interceptorProvider = CustomInterceptorProvider(
            client: client,
            store: store,
            tokenProvider: configuration.authorizationTokenProvider
        )
        let uploadTransport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider,
            endpointURL: baseURL
        )

        let splitTransport = SplitNetworkTransport(
            uploadingNetworkTransport: uploadTransport,
            webSocketNetworkTransport: localWebSocketTransport
        )

        let apolloClient = ApolloClient(networkTransport: splitTransport, store: store)
        self.client = apolloClient
        return apolloClient
    }

    func updateAuthorizationHeader(with token: String?) {
        guard let token = token, let webSocketTransport else {
            return
        }
        webSocketTransport.updateHeaderValues([authorizationKey : token])
    }
}
extension DefaultApolloClientProvider: WebSocketTransportDelegate {
    func webSocketTransportDidConnect(_ webSocketTransport: WebSocketTransport) {
        debugPrint("---> Apollo WebSocket connected")
    }
    func webSocketTransportDidReconnect(_ webSocketTransport: WebSocketTransport) {
        debugPrint("---> Apollo WebSocket did reconnect")
    }
    func webSocketTransport(_ webSocketTransport: WebSocketTransport, didDisconnectWithError error:(any Error)?) {
        debugPrint("---> Apollo didDisconnectWithError: \(error?.localizedDescription ?? "")")
    }
}
