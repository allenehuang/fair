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
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let resultsViewModel = ProviderResultsViewModel()

    init(results: [Result]) {
        super.init(nibName: nil, bundle: nil)
        resultsViewModel.results = results
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 60.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.sectionFooterHeight = 0.0

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
//        resultsViewModel.sortPrice(sort: .asc) { [weak self] in
//            self?.tableView.reloadData()
//        }
//        resultsViewModel.sortDistance(sort: .desc) { [weak self] in
//            self?.tableView.reloadData()
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProviderResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = resultsViewModel.results[section]
        return result.cars.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return resultsViewModel.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifierString) as? CarTableViewCell
        if cell == nil {
            cell = CarTableViewCell()
        }
        let car = resultsViewModel.results[indexPath.section].cars[indexPath.row]
        cell?.configureWith(car: car)
        return cell!
    }
}

extension ProviderResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CarProviderSectionHeader()
        headerView.configureWith(result: resultsViewModel.results[section])
        return headerView
    }
}
