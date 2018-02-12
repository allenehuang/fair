//
//  DetailViews.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import UIKit

class DisplayLabel: UIView {
    private let descriptionLabel = UILabel()
    private let valueLabel = UILabel()

    init(description: String, value: String) {
        super.init(frame: .zero)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        descriptionLabel.textAlignment = .left
        descriptionLabel.text = description
        valueLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        valueLabel.textAlignment = .right
        valueLabel.text = value
        addSubviewsForAutolayout(descriptionLabel, valueLabel)
        layoutViews()
    }

    private func layoutViews() {
        let views: [String: Any] = [
            "descriptionLabel": descriptionLabel,
            "valueLabel": valueLabel
        ]

        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[descriptionLabel][valueLabel]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[descriptionLabel]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[valueLabel]|", options: [], metrics: nil, views: views)
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VehicleInfoView: UIStackView {
    private let vehicleInfoLabel = DetailViewHeaderLabel()

    init(vehicleInfo: VehicleInfo) {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .fillEqually
        alignment = .fill
        spacing = 0.0
        addViews(vehicleInfo: vehicleInfo)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews(vehicleInfo: VehicleInfo) {
        vehicleInfoLabel.text = "VehicleInfo"
        addArrangedSubview(vehicleInfoLabel)

        let acrissLabel = DisplayLabel(description: "Acriss Code", value: vehicleInfo.acrissCode)
        addLabel(displayLabel: acrissLabel)

        let categoryLabel = DisplayLabel(description: "Category", value: vehicleInfo.category)
        addLabel(displayLabel: categoryLabel)

        if let transmissionString = vehicleInfo.transmission {
            let transmissionLabel = DisplayLabel(description: "Transmission", value: transmissionString)
            addLabel(displayLabel: transmissionLabel)
        }

        if let fuelString = vehicleInfo.fuel {
            let fuelLabel = DisplayLabel(description: "Fuel", value: fuelString)
            addLabel(displayLabel: fuelLabel)
        }

        if let airConditioningBool = vehicleInfo.airConditioning {
            let airConditioningLabel = DisplayLabel(description: "Air Conditioning", value: airConditioningBool ? "YES" : "NO")
            addLabel(displayLabel: airConditioningLabel)
        }

        if let typeString = vehicleInfo.type {
            let typeLabel = DisplayLabel(description: "Type", value: typeString)
            addLabel(displayLabel: typeLabel)
        }
    }

    private func addLabel(displayLabel: DisplayLabel) {
        addArrangedSubview(displayLabel)
    }
}

class RatesInfoView: UIStackView {
    private let ratesLabel = DetailViewHeaderLabel()

    init(rates: [Rate]) {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .fillEqually
        alignment = .fill
        spacing = 0.0
        addViews(rates: rates)
    }

    private func addViews(rates: [Rate]) {
        ratesLabel.text = "Rates"
        addArrangedSubview(ratesLabel)
        for rate in rates {
            let displayLabel = DisplayLabel(description: rate.type, value: "\(rate.price.currency) $\(rate.price.amount)")
            addArrangedSubview(displayLabel)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class DetailViewHeaderLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 25.0, weight: .bold)
        textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapPreviewImage: UIView {
    private let activityIndicator = UIActivityIndicatorView()
    private let imageView = UIImageView()

    convenience init() {
        self.init(frame: .zero)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        addSubviewsForAutolayout(imageView, activityIndicator)
        layoutViews()
    }

    private func layoutViews() {
        let views: [String: Any] = [
            "activityIndicator": activityIndicator,
            "imageView": imageView
        ]

        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[activityIndicator]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[activityIndicator]|", options: [], metrics: nil, views: views)
        )
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
        activityIndicator.stopAnimating()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
