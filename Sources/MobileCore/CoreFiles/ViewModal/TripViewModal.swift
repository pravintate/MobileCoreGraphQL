//
//  TripViewModal.swift
//  MobileCore
//
//  Created by pravin tate on 24/09/25.
//


class TripViewModal {
    let repository: TripRepository
    var task: Task<Void, Never>?
    var updateValue: ((_ value: String) -> Void)?

    init(repository: TripRepository = TripRepositoryImpl()) {
        self.repository = repository
    }

    func listenSubscription() {
        task = Task {
            do {
                let result = try await repository.subscribe()
                for try await result in result {
                    if let error = result.errors {
                        print("error |\(error)")
                        updateValue?(error.description)
                    }
                    if let value = result.data?.tripsBooked {
                        let str = String(value)
                        print("value |\(str)")
                        updateValue?(str)
                    }
                }
            } catch {
                updateValue?("error: \(error.localizedDescription)")
            }
        }
    }

    func stopListening() {
        task?.cancel()
        task = nil
    }
}