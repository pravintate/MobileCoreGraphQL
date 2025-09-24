//
//  TokenConfiguration.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//


final class TokenConfiguration {
    static let shared = TokenConfiguration()
    private var token = "dGF0ZS5wcmF2aW5AZ21haWwuY29t"
    var index = 0
    func getAuthorizationToken() -> String? {
        index += 1
        print("token updated here \(index)")
        return token
    }

    func setAuthorizationToken(_ value: String) {
        self.token = value
    }
}