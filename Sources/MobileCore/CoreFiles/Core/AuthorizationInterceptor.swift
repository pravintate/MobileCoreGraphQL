//
//  AuthorizationInterceptor.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//
import ApolloAPI
import Apollo
import Foundation

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
