//
//  TableViewCells.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class CarProviderSectionHeader: UIView {
    let providerNameLabel = UILabel()
    let providerAddressLabel = UILabel()
    let providerRegionLabel = UILabel()
    let providerDistanceLabel = UILabel()
    let labelContainer = UIView()
    let carCountContainer = CarCountContainer()
    var didUpdateConstraints = false

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsForAutolayout(labelContainer, carCountContainer, providerDistanceLabel)
        providerNameLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        providerAddressLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        providerRegionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        providerDistanceLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        providerDistanceLabel.textAlignment = .center
        providerAddressLabel.numberOfLines = 0
        labelContainer.addSubviewsForAutolayout(providerNameLabel, providerAddressLabel, providerRegionLabel)
        layoutViews()
    }

    func layoutViews() {
        let labelContainerViews: [String: Any] = [
            "nameLabel": providerNameLabel,
            "addressLabel": providerAddressLabel,
            "regionLabel": providerRegionLabel
        ]
        labelContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel][addressLabel][regionLabel]|", options: [], metrics: nil, views: labelContainerViews),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[nameLabel]|", options: [], metrics: nil, views: labelContainerViews),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[addressLabel]|", options: [], metrics: nil, views: labelContainerViews),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[regionLabel]|", options: [], metrics: nil, views: labelContainerViews)
        )

        let views: [String: Any] = [
            "labelContainer": labelContainer,
            "carCountContainer": carCountContainer,
            "distanceLabel": providerDistanceLabel
        ]

        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[labelContainer]-5-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[carCountContainer]-5-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[distanceLabel]-5-|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[labelContainer]-(>=10)-[distanceLabel]-10-[carCountContainer]-5-|", options: [], metrics: nil, views: views)
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func configureWith(result: Result) {
        providerNameLabel.text = "\(result.provider.companyName) (\(result.provider.companyCode))"
        providerAddressLabel.text = result.address.street
        var regionString: String
        if let region = result.address.region {
            regionString = "\(region) \(result.address.country)"
        } else {
            regionString = result.address.country
        }
        providerRegionLabel.text = regionString

        carCountContainer.numberOfCarsLabel.text = "\(result.cars.count)"

        guard let distance = result.location?.distance else { return }
//        guard let providerCoordinates = result.location?.coordinate else { return }
//        let providerLocation = CLLocation(latitude: providerCoordinates.latitude, longitude: providerCoordinates.longitude)
//        let currentLocation = CLLocation(latitude: LocationService.shared.currentLocation.latitude, longitude: LocationService.shared.currentLocation.longitude)
//        let distance = providerLocation.distance(from: currentLocation)
        providerDistanceLabel.text = LocationService.shared.getDistanceString(distance)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CarCountContainer: UIView {
    private let numberOfCarsDescriptionLabel = UILabel()
    let numberOfCarsLabel = UILabel()

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfCarsDescriptionLabel.textAlignment = .center
        numberOfCarsDescriptionLabel.text = NSLocalizedString("# of cars", comment: "cars")
        numberOfCarsDescriptionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        numberOfCarsLabel.textAlignment = .center
        numberOfCarsLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        addSubviewsForAutolayout(numberOfCarsDescriptionLabel, numberOfCarsLabel)
        layoutViews()
    }

    private func layoutViews() {
        let views: [String: Any] = [
            "descriptionLabel": numberOfCarsDescriptionLabel,
            "countLabel": numberOfCarsLabel
        ]

        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[descriptionLabel]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[countLabel]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=5)-[descriptionLabel][countLabel]-(>=5)-|", options: [], metrics: nil, views: views)
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CarTableViewCell: UITableViewCell {
    static let reuseIdentifierString = "carCell"
    private let labelContainer = UIView()
    private let acrissCodeLabel = UILabel()
    private let transmissionLabel = UILabel()
    private let categoryLabel = UILabel()
    private let pricingContainer = UIView()
    private let pricingDescriptionLabel = UILabel()
    private let totalLabel = UILabel()

    convenience init() {
        self.init(style: .default, reuseIdentifier: CarTableViewCell.reuseIdentifierString)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        acrissCodeLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        transmissionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        categoryLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        pricingDescriptionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        totalLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)

        contentView.addSubviewsForAutolayout(labelContainer, pricingContainer)
        labelContainer.addSubviewsForAutolayout(acrissCodeLabel, transmissionLabel, categoryLabel)
        pricingContainer.addSubviewsForAutolayout(pricingDescriptionLabel, totalLabel)
        layoutViews()
    }

    func layoutViews() {
        let metrics: [String: Any] = [
            "spacing": 5
        ]

        let labelViews: [String: Any] = [
            "acrissCodeLabel": acrissCodeLabel,
            "transmissionLabel": transmissionLabel,
            "categoryLabel": categoryLabel
        ]

        labelContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[acrissCodeLabel][transmissionLabel][categoryLabel]|", options: [], metrics: metrics, views: labelViews),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[acrissCodeLabel]|", options: [], metrics: metrics, views: labelViews),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[transmissionLabel]|", options: [], metrics: metrics, views: labelViews),
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[categoryLabel]|", options: [], metrics: metrics, views: labelViews)
        )

        let pricingViews: [String: Any] = [
            "rateLabel": pricingDescriptionLabel,
            "totalLabel": totalLabel
        ]

        pricingContainer.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[rateLabel]-spacing-[totalLabel]|", options: [], metrics: metrics, views: pricingViews),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[totalLabel]|", options: [], metrics: metrics, views: pricingViews),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[rateLabel]|", options: [], metrics: metrics, views: pricingViews)
        )

        let views: [String: Any] = [
            "labelContainer": labelContainer,
            "pricingContainer": pricingContainer
        ]

        contentView.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-spacing-[labelContainer]-(>=spacing)-[pricingContainer]-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-spacing-[labelContainer]-spacing-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-spacing-[pricingContainer]-spacing-|", options: [], metrics: metrics, views: views)
        )
    }

    func configureWith(car: Car) {
        acrissCodeLabel.text = car.vehicleInfo.acrissCode
        transmissionLabel.text = car.vehicleInfo.transmission
        categoryLabel.text = car.vehicleInfo.category
        totalLabel.text = car.estimatedTotal?.amount
        pricingDescriptionLabel.text = NSLocalizedString("Estimated Total:", comment: "estimated total string")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

