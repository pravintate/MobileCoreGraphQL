//
//  NetworkTest.swift
//  MobileCore
//
//  Created by pravin tate on 22/09/25.
//
import XCTest
@testable import MobileCore
@testable import MobileCoreAPI_Generated
@testable import Apollo

final class NetworkTests: XCTestCase {
    func testLauchRepository() async {
        let repository = LaunchRepositoryImpl()
        do {
            let result = try await repository.fetchLaunches()
            XCTAssertTrue(result.isEmpty == false)
            print(result.description)
        } catch {
            XCTFail(#file + "\n" + #function + "\n" + "\(error)")
        }
    }

    func testLoginRepository() async {
        let repository = LoginRepositoryImpl()
        do {
            let result = try await repository.doLogin("tate.pravin@gmail.com")
            XCTAssertTrue(result.token.isEmpty == false)
//            TokenConfiguration.shared.setAuthorizationToken(result.token)
        } catch {
            XCTFail((#file + "\n" + #function + "\n" + "\(error)"))
        }
    }

    func testBookTrip() async {
        let repository = BookTripRepositoryImpl()
        do {
            let result = try await repository.bookTrip(trips: ["1", "2"])
            XCTAssertTrue(result.isEmpty == false)
            XCTAssertTrue(result == "trips booked successfully")
        } catch {
            print(error)
        }
    }

    func testTripBookedSubscription() async throws {
        let expectation = expectation(description: "Receive trip booked update")

        let tripRepository = TripRepositoryImpl() // Your repository

        // 1️⃣ Start the subscription concurrently
        let subscriptionStream = try await tripRepository.subscribe()
        let subscriptionTask = Task {
            do {
                for try await result in subscriptionStream {
                    if let value = result.data?.tripsBooked {
                        let str = String(value)
                        print("Received trip booked update: \(str)")
                        expectation.fulfill()
                        break // Stop after first update if desired
                    }
                }
            } catch {
                XCTFail("Subscription failed: \(error)")
            }
        }

        // 2️⃣ Wait a tiny moment to ensure subscription is connected
        try await Task.sleep(nanoseconds: 5_000_000_000) // 0.5 sec

        // 3️⃣ Fire the mutation that triggers the subscription
        let bookRepo = BookTripRepositoryImpl()
        do {
            let result = try await bookRepo.bookTrip(trips: ["1", "2", "3", "4"])
            print("Mutation result: \(result)")
        } catch {
            XCTFail("Mutation failed: \(error)")
        }

        // 4️⃣ Wait for the subscription to emit (max 8 seconds)
        await fulfillment(of: [expectation], timeout: 8)

        // 5️⃣ Cancel the subscription task
        subscriptionTask.cancel()

        print("Done")
    }


    let viewModal = TripViewModal(repository: TripRepositoryImpl())
    func testViewModal() async throws {
        let expectation = DispatchSemaphore(value: 0) // Use for simple sync wait

        viewModal.updateValue = { value in
            print("Received value: \(value)")
            // Signal that we received an update
            expectation.signal()
        }

        viewModal.listenSubscription()
        try await Task.sleep(nanoseconds: 5_000_000_000) // 0.2 sec
        let repository = BookTripRepositoryImpl()
        do {
            let result = try await repository.bookTrip(trips: ["1", "2", "3", "4"])
            print("Mutation result: \(result)")
        } catch {
            XCTFail("Mutation failed: \(error)")
        }
        // Wait for the first value from subscription (timeout after 5 seconds)
        let timeout = DispatchTime.now() + .seconds(5)
        if expectation.wait(timeout: timeout) == .timedOut {
            print("Test timed out waiting for subscription value")
        }

        viewModal.stopListening()
    }
}

