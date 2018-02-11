//
//  ViewController.swift
//  fair
//
//  Created by Allen Huang on 2/5/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class ViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var results = [Result]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        let views: [String: Any] = ["tableView": tableView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: .alignAllCenterX, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: .alignAllCenterX, metrics: nil, views: views))

        var pickupDateComponents = DateComponents()
        pickupDateComponents.year = 2018
        pickupDateComponents.month = 6
        pickupDateComponents.day = 7

        var dropOffDateComponents = DateComponents()
        dropOffDateComponents.year = 2018
        dropOffDateComponents.month = 6
        dropOffDateComponents.day = 8

        let calendar = Calendar.current


        let tempLocation = CLLocationCoordinate2D(latitude: 34.081454899999997, longitude: -118.382063)
        CarSearchService.shared.search(location: tempLocation, radius: 10, pickUpDate: calendar.date(from: pickupDateComponents)!, dropOffDate: calendar.date(from: dropOffDateComponents)!) { [weak self] (results, error) in
            guard let results = results else { return }
            self?.results = results
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CarProviderTableViewCell.reuseIdentifierString) as? CarProviderTableViewCell
        if cell == nil {
            cell = CarProviderTableViewCell()
        }
        let result = results[indexPath.row]
        cell?.configureWith(result: result)
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let providerDetailViewController = ProviderDetailViewController(result: results[indexPath.row])
        navigationController?.pushViewController(providerDetailViewController, animated: true)
    }
}
