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
    let descriptionLabel = UILabel()
    let valueLabel = UILabel()

    init(description: String, value: String) {
        super.init(frame: .zero)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        descriptionLabel.textAlignment = .left
        valueLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        valueLabel.textAlignment = .right
        addSubviewsForAutolayout(descriptionLabel, valueLabel)
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
