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
    private let apiKey = "BH0YcvY52j0ee98eMLf9YMoHUjzzqZTi"
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
                let jsonRepresentation = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                print(jsonRepresentation)
                do {
                    /*
                     {
                     message = "An unexpected server error occured. Try again in a few minutes, maybe it will work. Otherwise, contact support with this response message";
                     "more_info" = "A java.lang.RuntimeException occurred at system time 1518236173932";
                     status = 500;
                     }
                     */
                    // if status is 200 else show the message
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(RentalCarSearchResults.self, from: data)
                    DispatchQueue.main.async {
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

