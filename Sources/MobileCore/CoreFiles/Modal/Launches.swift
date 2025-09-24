//
//  Launches.swift
//  MobileCore
//
//  Created by pravin tate on 23/09/25.
//
import MobileCoreAPI_Generated
import ApolloAPI
import Apollo

struct LaunchDomain: CustomStringConvertible {
    let id: String
    let site: String?

    var description: String {
        "Launch(id: \(id), site: \(site ?? "nil"))"
    }
}

