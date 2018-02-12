//
//  CarDetailViewController.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import UIKit

class CarDetailViewController: UIViewController {
    let vehicleInfoView: VehicleInfoView
    let ratesInfoView: RatesInfoView
    let mapPreviewImage = UIImageView()
    let activityIndicator = UIActivityIndicatorView()
    let result: Result

    init(result: Result, car: Car) {
        self.result = result
        self.vehicleInfoView = VehicleInfoView(vehicleInfo: car.vehicleInfo)
        self.ratesInfoView = RatesInfoView(rates: car.rates)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        mapPreviewImage.isUserInteractionEnabled = true

        view.addSubviewsForAutolayout(vehicleInfoView, ratesInfoView, mapPreviewImage)
        mapPreviewImage.addSubview(activityIndicator)
        layoutViews()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMapPreview))
        mapPreviewImage.addGestureRecognizer(tapGestureRecognizer)

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityIndicator.frame = mapPreviewImage.bounds
        activityIndicator.activityIndicatorViewStyle = .gray
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let coordinates = result.location?.coordinate, mapPreviewImage.bounds.size != .zero else { return }
        MapPreviewService.shared.createImageFor(coordinate: coordinates, size: mapPreviewImage.bounds.size) { [weak self] (mapPreviewImage) in
            self?.mapPreviewImage.image = mapPreviewImage
            self?.activityIndicator.stopAnimating()
        }
    }

    @objc func didTapMapPreview() {
        let directionsViewController = MapDirectionsViewController(result: result)
        navigationController?.pushViewController(directionsViewController, animated: true)
    }

    private func layoutViews() {
        let views: [String: Any] = [
            "vehicleInfoView": vehicleInfoView,
            "ratesInfoView": ratesInfoView
        ]

        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[vehicleInfoView]-[ratesInfoView(==vehicleInfoView)]-5-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[vehicleInfoView]", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[ratesInfoView]", options: [], metrics: nil, views: views)
        )

        view.addConstraints([
            NSLayoutConstraint(item: mapPreviewImage, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 10),
            NSLayoutConstraint(item: mapPreviewImage, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -10),
            NSLayoutConstraint(item: mapPreviewImage, attribute: .top, relatedBy: .equal, toItem: vehicleInfoView, attribute: .bottom, multiplier: 1.0, constant: 30),
            NSLayoutConstraint(item: mapPreviewImage, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -30)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

