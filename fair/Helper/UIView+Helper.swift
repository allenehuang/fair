//
//  UIViewHelper.swift
//  fair
//
//  Created by Allen Huang on 2/10/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSubviewsForAutolayout(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }

    func addConstraints(_ constraints: [NSLayoutConstraint]...) {
        addConstraints(constraints.flatMap { $0 })
    }
}
