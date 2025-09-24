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

        let tripRepository = TripRepositoryImpl() // pass your actual ApolloNetworkImpl
        var subscription: Apollo.Cancellable?

        // 1️⃣ Start listening for subscription updates
        subscription = tripRepository.observeTripBooked { tripsBooked in
            if let booked = tripsBooked {
                print("Number of trips booked: \(booked)")
                expectation.fulfill() // subscription fired
            } else {
                XCTFail("Failed to get booked trips update")
            }
        }

        // 2️⃣ Wait a tiny moment to ensure the subscription is connected
        try await Task.sleep(nanoseconds: 5_000_000_000) // 0.2 sec
        
        print("fire query now")
        // 3️⃣ Perform the mutation that triggers the subscription
        let repository = BookTripRepositoryImpl()
        do {
            let result = try await repository.bookTrip(trips: ["1", "2", "3", "4"])
            print("Mutation result: \(result)")
        } catch {
            XCTFail("Mutation failed: \(error)")
        }

        // 4️⃣ Wait for the subscription to emit
        await fulfillment(of: [expectation], timeout: 8)
        // 5️⃣ Cancel subscription to clean up
        subscription?.cancel()
        print("done")
    }
}

