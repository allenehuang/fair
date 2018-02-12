//
//  MapPreviewService.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class MapPreviewService {
    static let shared = MapPreviewService()
    private var mapSnapshotOptions: MKMapSnapshotOptions
    private let regionalDistance: CLLocationDistance = 10000

    private init() {
        self.mapSnapshotOptions = MKMapSnapshotOptions()
        self.mapSnapshotOptions.scale = UIScreen.main.scale
        self.mapSnapshotOptions.showsBuildings = true
        self.mapSnapshotOptions.showsPointsOfInterest = false
    }
}
