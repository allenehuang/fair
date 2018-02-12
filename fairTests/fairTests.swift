//
//  fairTests.swift
//  fairTests
//
//  Created by Allen Huang on 2/5/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import XCTest
@testable import fair

class fairTests: XCTestCase {
    var providerResultsViewModel = ProviderResultsViewModel()
    var results = [Result]()

    override func setUp() {
        super.setUp()
        results = generateResults()
        providerResultsViewModel.results = results
    }
    
    override func tearDown() {
        results.removeAll()
        super.tearDown()
    }
    
    func testSortCompanyAscending() {
        let expectationCallBack = expectation(description: "sorts by ascending order")
        providerResultsViewModel.sortCompanyName(sort: .asc) {
            XCTAssertEqual("ABC", self.providerResultsViewModel.results[0].provider.companyName)
            XCTAssertEqual("CBA", self.providerResultsViewModel.results[self.results.count-1].provider.companyName)
            expectationCallBack.fulfill()
        }
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("Error:\(error)")
            }
        }
    }

    func testSortCompanyDescending() {
        let expectationCallBack = expectation(description: "sorts by descending order")
        providerResultsViewModel.sortCompanyName(sort: .desc) {
            XCTAssertEqual("CBA", self.providerResultsViewModel.results[0].provider.companyName)
            XCTAssertEqual("ABC", self.providerResultsViewModel.results[self.results.count-1].provider.companyName)
            expectationCallBack.fulfill()
        }
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("Error:\(error)")
            }
        }
    }

    func testSortPriceAscending() {
        let expectationCallBack = expectation(description: "sorts by ascending order")
        providerResultsViewModel.sortPrice(sort: .asc) {
            XCTAssertEqual("0", self.providerResultsViewModel.results[0].cars[0].estimatedTotal?.amount)
            XCTAssertEqual("900", self.providerResultsViewModel.results[0].cars[self.providerResultsViewModel.results[0].cars.count-1].estimatedTotal?.amount)
            expectationCallBack.fulfill()
        }
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("Error:\(error)")
            }
        }
    }

    func testSortPriceDescending() {
        let expectationCallBack = expectation(description: "sorts by descending order")
        providerResultsViewModel.sortPrice(sort: .desc) {
            XCTAssertEqual("900", self.providerResultsViewModel.results[0].cars[0].estimatedTotal?.amount)
            XCTAssertEqual("0", self.providerResultsViewModel.results[0].cars[self.providerResultsViewModel.results[0].cars.count-1].estimatedTotal?.amount)
            expectationCallBack.fulfill()
        }
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("Error:\(error)")
            }
        }
    }

    func testSortDistanceAscending() {
        let expectationCallBack = expectation(description: "sorts by ascending order")
        providerResultsViewModel.sortDistance(sort: .asc) {
            XCTAssertEqual(15, self.providerResultsViewModel.results[0].location?.distance)
            XCTAssertEqual(50, self.providerResultsViewModel.results[self.results.count-1].location?.distance)
            expectationCallBack.fulfill()
        }

        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("Error:\(error)")
            }
        }
    }

    func testSortDistanceDescending() {
        let expectationCallBack = expectation(description: "sorts by descending order")
        providerResultsViewModel.sortDistance(sort: .desc) {
            XCTAssertEqual(50, self.providerResultsViewModel.results[0].location?.distance)
            XCTAssertEqual(15, self.providerResultsViewModel.results[self.results.count-1].location?.distance)
            expectationCallBack.fulfill()
        }

        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("Error:\(error)")
            }
        }
    }

    func generateResults() -> [Result] {
        var results = [Result]()
        let genericAddress = Address(street: "123 street", city: "Los Angeles", region: "CA", country: "USA")

        let firstProvider = Provider(companyCode: "ABC", companyName: "ABC")
        let firstLocation = Location(latitude: 35.0, longitude: 115.0, distance: 20)
        let firstResult = Result(provider: firstProvider, branchID: "123", location: firstLocation, address: genericAddress, cars: generateCars())
        results.append(firstResult)

        let secondProvider = Provider(companyCode: "BAC", companyName: "BAC")
        let secondLocation = Location(latitude: 35.0, longitude: 115.0, distance: 15)
        let secondResult = Result(provider: secondProvider, branchID: "123", location: secondLocation, address: genericAddress, cars: generateCars())
        results.append(secondResult)

        let thirdProvider = Provider(companyCode: "CBA", companyName: "CBA")
        let thirdLocation = Location(latitude: 35.0, longitude: 115.0, distance: 50)
        let thirdResult = Result(provider: thirdProvider, branchID: "123", location: thirdLocation, address: genericAddress, cars: generateCars())
        results.append(thirdResult)

        return results
    }

    func generateCars() -> [Car] {
        let genericVehicleInfo = VehicleInfo(acrissCode: "AcrissCode", transmission: "Transimission", fuel: "Fuel Type", airConditioning: true, category: "Hot Wheels", type: "Truck")
        let genericPrice = Price(amount: "100.0", currency: "USD")
        let genericRate = Rate(type: "DAILY", price: genericPrice)
        var cars = [Car]()

        for index in 0..<10 {
            let estimatedTotal = EstimatedTotal(amount: "\(index * 100)", currency: "USD")
            let car = Car(vehicleInfo: genericVehicleInfo, rates: [genericRate], estimatedTotal: estimatedTotal)
            cars.append(car)
        }
        return cars
    }
}
