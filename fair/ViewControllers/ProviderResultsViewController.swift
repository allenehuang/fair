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
    private let sortPickerView = SortPickerView()

    init(results: [Result]) {
        super.init(nibName: nil, bundle: nil)
        resultsViewModel.results = results
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sortPickerView.delegate = self
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

        guard let navigationControllerView = navigationController?.view else { return }

        let navigationViews: [String: Any] = [
            "sortPickerView": sortPickerView
        ]
        navigationControllerView.addSubviewsForAutolayout(sortPickerView)

        navigationControllerView.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[sortPickerView]|", options: [], metrics: nil, views: navigationViews),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[sortPickerView]|", options: [], metrics: nil, views: navigationViews)
        )
    }

    @objc private func didTapSortButton(_ button: UIBarButtonItem) {
        sortPickerView.showView(true)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = resultsViewModel.results[indexPath.section]
        let car = result.cars[indexPath.row]
        let carDetailViewController = CarDetailViewController(result: result, car: car)
        navigationController?.pushViewController(carDetailViewController, animated: true)
    }
}

extension ProviderResultsViewController: SortPickerViewDelegate {
    func dismissedWith(sortValue: SortValue, sortType: SortType) {
        switch sortValue {
        case .company:
            resultsViewModel.sortCompanyName(sort: sortType, completion: { [weak self] in
                self?.tableView.reloadData()
            })
        case .distance:
            resultsViewModel.sortDistance(sort: sortType, completion: { [weak self] in
                self?.tableView.reloadData()
            })
        case .price:
            resultsViewModel.sortPrice(sort: sortType, completion: { [weak self] in
                self?.tableView.reloadData()
            })
        }
    }
}
