//
//  CarRentalMap.swift
//  fair
//
//  Created by Allen Huang on 2/9/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation

enum ViewType {
    case map
    case list
}

class CarRentalMapViewController: UIViewController {
    private let mapView = MKMapView()
    private let searchButton = DateButton()
    private var results = [Result]()
    private var dateButtonContainer = DateButtonContainerView()
    private var mapViewModel = CarRentalMapViewModel()
    private let datePickerContainer = DatePickerContainerView()
    private var observations = [NSKeyValueObservation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.shared.startLocationServices()
        setupViews()
        view.addSubview(mapView)
        view.addSubviewsForAutolayout(searchButton, dateButtonContainer)
        layoutViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        observations.removeAll()
        super.viewDidDisappear(animated)
    }

    private func setupViews() {
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mapView.showsUserLocation = true

        searchButton.setTitle(mapViewModel.searchButtonText, for: .normal)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)

        dateButtonContainer.setupViewsWith(viewModel: mapViewModel)
        dateButtonContainer.pickUpButton.addTarget(self, action: #selector(didTapPickUpDate), for: .touchUpInside)
        dateButtonContainer.dropOffButton.addTarget(self, action: #selector(didTapDropOffDate), for: .touchUpInside)

        datePickerContainer.datePicker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)
    }

    private func layoutViews() {
        let views: [String: Any] = [
            "searchButton": searchButton,
            "dateButtonContainer": dateButtonContainer
        ]
        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchButton]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dateButtonContainer]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:[dateButtonContainer(==50)][searchButton(==80)]|", options: [], metrics: nil, views: views)
        )

        guard let navigationControllerView = navigationController?.view else { return }

        let navigationViews: [String: Any] = [
            "datePickerContainer": datePickerContainer
        ]
        navigationControllerView.addSubviewsForAutolayout(datePickerContainer)

        navigationControllerView.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[datePickerContainer]|", options: [], metrics: nil, views: navigationViews),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[datePickerContainer]|", options: [], metrics: nil, views: navigationViews)
        )
    }

    private func addObservers() {
        let currentLocationObserver = LocationService.shared.observe(\.currentLocation) { [weak self] observed, _ in
            self?.mapView.setRegion(MKCoordinateRegionMake(observed.currentLocation, MKCoordinateSpanMake(1, 1)), animated: true)
            
        }
        observations.append(currentLocationObserver)
    }

    @objc private func datePickerDidChange(_ picker: DatePicker) {
        guard let type = picker.type else { return }
        switch type {
        case .pickup:
            mapViewModel.pickUpDate = picker.date
        case .dropoff:
            mapViewModel.dropOffDate = picker.date
        }
    }

    @objc private func didTapSearchButton() {
        mapView.removeAnnotations(mapView.annotations)
        mapViewModel.searchWith(location: mapView.userLocation.coordinate) {[weak self] (error) in
            if let error = error {
                self?.displayAlertViewWith(error: error)
            } else if let results = self?.mapViewModel.results {
                let resultsViewController = ProviderResultsViewController(results: results)
                self?.navigationController?.pushViewController(resultsViewController, animated: true)
            }
        }
    }

    @objc private func didTapPickUpDate() {
        datePickerContainer.datePicker.date = mapViewModel.pickUpDate
        datePickerContainer.showView(true, type: .pickup)
    }

    @objc private func didTapDropOffDate() {
        datePickerContainer.datePicker.date = mapViewModel.dropOffDate
        datePickerContainer.showView(true, type: .dropoff)
    }

    private func displayAlertViewWith(error: Error) {
        let alertViewController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let confirmationAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(confirmationAction)
        present(alertViewController, animated: true, completion: nil)
    }
}

extension CarRentalMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        mapView.setCenter(location, animated: false)
        mapView.setRegion(MKCoordinateRegionMake(location, MKCoordinateSpanMake(1, 1)), animated: true)
    }
}

