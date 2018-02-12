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

    init(result: Result, car: Car) {
        self.vehicleInfoView = VehicleInfoView(vehicleInfo: car.vehicleInfo)
        self.ratesInfoView = RatesInfoView(rates: car.rates)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        view.addSubviewsForAutolayout(vehicleInfoView, ratesInfoView)
        layoutViews()
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

