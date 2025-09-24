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
extension LaunchListQuery.Data.Launches {
    func toDomain() -> [LaunchDomain] {
        launches.compactMap { $0?.toDomain() }
    }
}

extension LaunchListQuery.Data.Launches.Launch {
    func toDomain() -> LaunchDomain {
        LaunchDomain(id: self.id, site: self.site)
    }
}
