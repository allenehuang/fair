//
//  MapDirectionsViewController.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import MapKit

class MapDirectionsViewController: UIViewController {
    private let mapView = MKMapView()
    private let result: Result

    init(result: Result) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Directions"
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)

        let destinationPoint = MKPointAnnotation()
        guard let coordinate = result.location?.coordinate else { return }
        destinationPoint.coordinate = coordinate
        mapView.addAnnotation(destinationPoint)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showDirections()
    }

    private func showDirections() {
        guard let destinationCoordinate = result.location?.coordinate else { return }
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: LocationService.shared.currentLocation))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        directionsRequest.transportType = .automobile

        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self] (response, error) in
            guard let response = response else { return }
            for route in response.routes {
                self?.mapView.add(route.polyline)
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapDirectionsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
}

