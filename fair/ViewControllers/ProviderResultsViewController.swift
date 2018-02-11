//
//  ProviderResultsViewController.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation
import UIKit

class ProviderResultsViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    let resultsViewModel = ProviderResultsViewModel()

    init(results: [Result]) {
        super.init(nibName: nil, bundle: nil)
        resultsViewModel.results = results
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        view.addSubviewsForAutolayout(tableView)
        layoutViews()

        let sortButton = UIBarButtonItem(title: resultsViewModel.sortButtonString, style: .plain, target: self, action: #selector(didTapSortButton(_:)))
        navigationItem.rightBarButtonItem = sortButton
    }

    func layoutViews() {
        let views: [String: Any] = [
            "tableView": tableView
        ]

        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: [], metrics: nil, views: views)
        )
    }

    @objc private func didTapSortButton(_ button: UIBarButtonItem) {

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProviderResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsViewModel.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CarProviderTableViewCell.reuseIdentifierString) as? CarProviderTableViewCell
        if cell == nil {
            cell = CarProviderTableViewCell()
        }
        cell?.configureWith(result: resultsViewModel.results[indexPath.row])
        return cell!
    }
}
