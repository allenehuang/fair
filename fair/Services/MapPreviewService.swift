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

    func createImageFor(coordinate: CLLocationCoordinate2D, size: CGSize, completion: @escaping (UIImage)->()) {
        mapSnapshotOptions.region = MKCoordinateRegionMakeWithDistance(coordinate, regionalDistance, regionalDistance)
        mapSnapshotOptions.size = size

        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        snapShotter.start { (snapshot: MKMapSnapshot?, error: Error?) in
            guard let mapPreview = snapshot?.image else { return }
            DispatchQueue.main.async {
                completion(mapPreview)
            }
        }
    }
}
