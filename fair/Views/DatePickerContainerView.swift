//
//  DatePickerContainerView.swift
//  fair
//
//  Created by Allen Huang on 2/10/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import UIKit

class DatePickerContainerView: UIView {
    let datePicker = DatePicker()
    private let blackOverlay = UIControl()
    private var pickerYConstraint: NSLayoutConstraint?

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        isHidden = true
        blackOverlay.backgroundColor = .black
        blackOverlay.alpha = 0.0
        addSubviewsForAutolayout(blackOverlay, datePicker)
        layoutViews()

        blackOverlay.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }

    private func layoutViews() {
        let views: [String: Any] = [
            "blackOverlay": blackOverlay
        ]

        addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[blackOverlay]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[blackOverlay]|", options: [], metrics: nil, views: views)
        )
        pickerYConstraint = NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)

        addConstraints([
            NSLayoutConstraint(item: datePicker, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: datePicker, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: datePicker.intrinsicContentSize.height),
            pickerYConstraint!
            ])
    }

    func showView(_ show: Bool, type: DatePickerType? = nil) {
        datePicker.type = type
        isHidden = false
        pickerYConstraint?.constant = show ? -datePicker.bounds.size.height : 0.0

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blackOverlay.alpha = show ? 0.5 : 0.0
            self?.layoutIfNeeded()
        }) { [weak self] (_) in
            if !show {
                self?.isHidden = true
            }
        }
    }

    @objc private func dismissView() {
        showView(false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


enum DatePickerType {
    case dropoff
    case pickup
}

class DatePicker: UIDatePicker {
    var type: DatePickerType?

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        timeZone = NSTimeZone.local
        datePickerMode = .date
        minimumDate = Date()
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
