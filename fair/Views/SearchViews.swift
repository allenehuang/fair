//
//  MapViews.swift
//  fair
//
//  Created by Allen Huang on 2/10/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import UIKit

class DateButtonContainerView: UIView {
    let pickUpButton = DateButton()
    let dropOffButton = DateButton()
    private let pickUpLabel = DateLabel()
    private let dropOffLabel = DateLabel()
    private var observations = [NSKeyValueObservation]()
    private var viewModel: CarRentalMapViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewsForAutolayout(pickUpButton, dropOffButton, pickUpLabel, dropOffLabel)
        layoutViews()
        addObservers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViewsWith(viewModel: CarRentalMapViewModel) {
        self.viewModel = viewModel
        pickUpLabel.text = viewModel.pickUpLabelText
        dropOffLabel.text = viewModel.dropOffLabelText
        pickUpButton.setTitle(viewModel.pickUpDateString, for: .normal)
        dropOffButton.setTitle(viewModel.dropOffDateString, for: .normal)
        addObservers()
    }

    private func layoutViews() {
        let views: [String: Any] = [
            "pickUpLabel": pickUpLabel,
            "dropOffLabel": dropOffLabel,
            "pickUpButton": pickUpButton,
            "dropOffButton": dropOffButton
        ]

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pickUpLabel(==20)][pickUpButton]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dropOffLabel(==20)][dropOffButton]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pickUpButton][dropOffButton(==pickUpButton)]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pickUpLabel][dropOffLabel(==pickUpLabel)]|", options: [], metrics: nil, views: views))
    }

    private func addObservers() {
        guard let viewModel = viewModel else { return }
        let pickUpDateObservation = viewModel.observe(\.pickUpDate) { [weak self] observed, _ in
            self?.pickUpButton.setTitle(observed.pickUpDateString, for: .normal)
        }
        observations.append(pickUpDateObservation)

        let dropOffDateObservation = viewModel.observe(\.dropOffDate) { [weak self] observed, _ in
            self?.dropOffButton.setTitle(observed.dropOffDateString, for: .normal)
        }
        observations.append(dropOffDateObservation)
    }

    deinit {
        observations.removeAll()
    }
}

class DateButton: UIButton {
    convenience init() {
        self.init(frame: .zero)
        titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray, for: .highlighted)
        backgroundColor = .black
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DateLabel: UILabel {
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 10, weight: .light)
        textColor = .white
        backgroundColor = .black
        textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
