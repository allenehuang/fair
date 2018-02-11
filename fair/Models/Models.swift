//
//  Models.swift
//  fair
//
//  Created by Allen Huang on 2/9/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import CoreLocation

struct RentalCarSearchResults: Codable {
    let results: [Result]
}

struct Result: Codable {
    let provider: Provider
    let branchID: String
    let location: Location?
    let address: Address
    let cars: [Car]

    enum CodingKeys: String, CodingKey {
        case provider
        case branchID = "branch_id"
        case location
        case address
        case cars
    }
}

struct Provider: Codable {
    let companyCode: String
    let companyName: String

    enum CodingKeys: String, CodingKey {
        case companyCode = "company_code"
        case companyName = "company_name"
    }
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Address: Codable {
    let street: String
    let city: String
    let region: String?
    let country: String

    enum CodingKeys: String, CodingKey {
        case street = "line1"
        case city
        case region
        case country
    }
}

struct Car: Codable {
    let vehicleInfo: VehicleInfo
    let rates: [Rate]
    let estimatedTotal: EstimatedTotal?

    enum CodingKeys: String, CodingKey {
        case vehicleInfo = "vehicle_info"
        case rates
        case estimatedTotal = "estimated_total"
    }
}

struct VehicleInfo: Codable {
    let acrissCode: String
    let transmission: String?
    let fuel: String?
    let airConditioning: Bool?
    let category: String
    let type: String?

    enum CodingKeys: String, CodingKey {
        case acrissCode = "acriss_code"
        case transmission
        case fuel
        case airConditioning = "air_conditioning"
        case category
        case type
    }
}

struct Rate: Codable {
    let type: String
    let price: Price
}

struct Price: Codable {
    let amount: String
    let currency: String
}

struct EstimatedTotal: Codable {
    let amount: String
    let currency: String
}
