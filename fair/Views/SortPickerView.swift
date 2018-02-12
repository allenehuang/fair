//
//  ResultsViews.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import UIKit

enum SortValue: Int {
    case company = 0
    case price
    case distance
}

enum SortType: Int {
    case asc = 0
    case desc
}

protocol SortPickerViewDelegate: class {
    func dismissedWith(sortValue: SortValue, sortType: SortType)
}

class SortPickerView: UIView {
    private let picker = UIPickerView()
    private let blackOverlay = UIControl()
    private var pickerYConstraint: NSLayoutConstraint?
    weak var delegate: SortPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        blackOverlay.backgroundColor = .black
        blackOverlay.alpha = 0.0
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        addSubviewsForAutolayout(blackOverlay, picker)
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
        pickerYConstraint = NSLayoutConstraint(item: picker, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)

        addConstraints([
            NSLayoutConstraint(item: picker, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: picker, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: picker.intrinsicContentSize.height),
            pickerYConstraint!
            ])
    }

    func showView(_ show: Bool) {
        isHidden = false
        pickerYConstraint?.constant = show ? -picker.bounds.size.height : 0.0

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blackOverlay.alpha = show ? 0.5 : 0.0
            self?.layoutIfNeeded()
        }) { [weak self] (_) in
            if !show {
                self?.isHidden = true

                if let sortValue = self?.picker.selectedRow(inComponent: 0), let sortType = self?.picker.selectedRow(inComponent: 1), let sortEnumValue = SortValue(rawValue: sortValue), let sortEnumType = SortType(rawValue: sortType) {
                    self?.delegate?.dismissedWith(sortValue: sortEnumValue, sortType: sortEnumType)
                }
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

extension SortPickerView: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 3
        } else {
            return 2
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
}

extension SortPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            switch row {
            case SortValue.company.rawValue:
                return "Company Name"
            case SortValue.distance.rawValue:
                return "Distance"
            case SortValue.price.rawValue:
                return "Price"
            default:
                return ""
            }
        } else {
            switch row {
            case SortType.asc.rawValue:
                return "Ascending"
            case SortType.desc.rawValue:
                return "Descending"
            default:
                return ""
            }
        }
    }
}
