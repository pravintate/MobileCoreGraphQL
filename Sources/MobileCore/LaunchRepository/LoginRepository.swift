//
//  LoginRepository.swift
//  MobileCore
//
//  Created by pravin tate on 23/09/25.
//
import MobileCoreAPI_Generated

protocol LoginRepository {
    func doLogin(_ emailId: String) async throws -> Login
}
struct LoginRepositoryImpl: LoginRepository {
    private let network: GraphQLNetwork

    init(networkFactory: ApolloNetworkFactory = ApolloNetworkFactoryImpl(),
         configurationProvider: ApolloConfigurationProvider = DefaultApolloConfigurationProvider()) {
        self.network = networkFactory.makeNetwork(configurationProvider: configurationProvider)
    }
    func doLogin(_ emailId: String) async throws -> Login {
        let result = try await network.perform(mutation: LoginMutation(email: emailId))
        if let token = result.login?.token {
            return Login(token: token)
        }
        throw ApolloError.noData
    }
}
