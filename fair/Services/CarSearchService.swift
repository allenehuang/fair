//
//  CarSearchService.swift
//  fair
//
//  Created by Allen Huang on 2/9/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import CoreLocation

class CarSearchService {
    static let shared = CarSearchService()
    private let apiKey = ""
    private let host = "api.sandbox.amadeus.com"
    private let scheme = "https"
    private let dateFormatter = DateFormatter()

    private init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    func search(location: CLLocationCoordinate2D, radius: NSInteger, pickUpDate: Date, dropOffDate: Date, completion: @escaping ([Result]?, Error?) -> ()) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/v1.2/cars/search-circle"

        let queryItemKey = URLQueryItem(name: "apikey", value: apiKey)
        let queryItemLat = URLQueryItem(name: "latitude", value: "\(location.latitude)")
        let queryItemLon = URLQueryItem(name: "longitude", value: "\(location.longitude)")
        let queryItemRadius = URLQueryItem(name: "radius", value: "\(radius)")
        let queryItemPickUpDate = URLQueryItem(name: "pick_up", value: dateFormatter.string(from: pickUpDate))
        let queryItemDropOffDate = URLQueryItem(name: "drop_off", value: dateFormatter.string(from: dropOffDate))

        components.queryItems = [queryItemKey, queryItemLat, queryItemLon, queryItemRadius, queryItemPickUpDate, queryItemDropOffDate]

        URLSession.shared.dataTask(with: components.url!) { data, response, error in
            if let data = data {
//                let jsonRepresentation = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                print(jsonRepresentation)
                do {
                    let decoder = JSONDecoder()
                    var results = try decoder.decode(RentalCarSearchResults.self, from: data)
                    DispatchQueue.main.async {
                        for index in results.results.indices {
                            guard let resultCoordinate = results.results[index].location?.coordinate else { return }
                            results.results[index].location?.distance = CLLocation(latitude: location.latitude, longitude: location.longitude).distance(from: CLLocation(latitude: resultCoordinate.latitude, longitude: resultCoordinate.longitude))
                        }
                        completion(results.results, nil)
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }.resume()
    }
}

