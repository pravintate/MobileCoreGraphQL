//
//  LaunchDTO.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//
import MobileCoreAPI_Generated
import ApolloAPI

typealias LaunchDTOList = LaunchListQuery.Data.Launches
typealias LaunchDTO = LaunchDTOList.Launch

extension LaunchDTO: DomainConvertible {
    typealias Domain = LaunchDomain
    func toDomain() -> LaunchDomain {
        LaunchDomain(id: self.id, site: self.site)
    }
}
extension LaunchDTOList: DomainConvertible {
    func toDomain() -> [LaunchDomain] {
        launches.toDomain()
    }
}
