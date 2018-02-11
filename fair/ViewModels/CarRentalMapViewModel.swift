//
//  CarRentalMapViewModel.swift
//  fair
//
//  Created by Allen Huang on 2/10/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import CoreLocation

class CarRentalMapViewModel: NSObject {
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

    let searchButtonText = NSLocalizedString("Search For Nearby Car Rentals", comment: "text for search button")
    let pickUpLabelText = NSLocalizedString("Pick Up Date", comment: "pick up date label")
    let dropOffLabelText = NSLocalizedString("Drop Off Date", comment: "drop off date label")

    @objc dynamic var dropOffDate = Date()
    @objc dynamic var pickUpDate = Date()

    var dropOffDateString: String {
        return dateFormatter.string(from: dropOffDate)
    }
    var pickUpDateString: String {
        return dateFormatter.string(from: pickUpDate)
    }

    var results = [Result]()

    func searchWith(location: CLLocationCoordinate2D, completion: @escaping (Error?) -> ()) {
        CarSearchService.shared.search(location: location, radius: 42, pickUpDate: pickUpDate, dropOffDate: dropOffDate) { [weak self] (results, error) in
            if let results = results {
                self?.results = results
            }
            completion(error)
        }
    }
}
