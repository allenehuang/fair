//
//  LocationService.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()
    private let locationManager = CLLocationManager()
    @objc dynamic var currentLocation: CLLocationCoordinate2D

    override init() {
        self.currentLocation = kCLLocationCoordinate2DInvalid
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }

    func startLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }

    func getDistanceString(_ distance: CLLocationDistance) -> String {
        var roundedDistance = lround(distance)
        if roundedDistance >= 1000 {
            roundedDistance = lround(distance / 1000.0)
            return "\(roundedDistance) km"
        } else {
            return "\(roundedDistance) m"
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        currentLocation = location
    }
}
