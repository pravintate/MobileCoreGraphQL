//
//  DTO.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//
protocol DomainConvertible {
    associatedtype DomainModel
    func toDomain() -> DomainModel
}

extension Array where Element: DomainConvertible {
    func toDomain() -> [Element.DomainModel] {
        compactMap({ $0.toDomain() })
    }
}
// Optional array version
extension Array where Element: OptionalType, Element.Wrapped: DomainConvertible {
    func toDomain() -> [Element.Wrapped.DomainModel] {
        compactMap { $0.value?.toDomain() }
    }
}

// Helper protocol
protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? { self }
}
