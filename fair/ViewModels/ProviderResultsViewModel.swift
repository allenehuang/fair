//
//  ProviderResultsViewModel.swift
//  fair
//
//  Created by Allen Huang on 2/11/18.
//  Copyright © 2018 Allen Huang. All rights reserved.
//

import Foundation

enum SortType {
    case asc
    case desc
}

class ProviderResultsViewModel: NSObject {
    var results = [Result]()
    let sortButtonString = NSLocalizedString("Sort", comment: "sort button string")

    func sortPrice(sort: SortType, completion: @escaping ()->()) {
        for index in results.indices {
            results[index].cars = results[index].cars.sorted(by: {
            guard let estimatedTotal0 = $0.estimatedTotal, let estimatedTotal1 = $1.estimatedTotal, let amount0 = Double(estimatedTotal0.amount), let amount1 = Double(estimatedTotal1.amount)
                else { return false }
                if sort == .desc {
                    return amount0 > amount1
                } else {
                    return amount0 < amount1
                }
            })
        }
        DispatchQueue.main.async {
            completion()
        }
    }

    func sortDistance(sort: SortType, completion: @escaping ()->()) {
        results = results.sorted(by: {
            guard let location0 = $0.location, let location1 = $1.location, let distance0 = location0.distance, let distance1 = location1.distance else { return false }
            if sort == .desc {
                return distance0 > distance1
            } else {
                return distance0 < distance1
            }
        })
        DispatchQueue.main.async {
            completion()
        }
    }

    func sortCompanyName(sort: SortType, completion: @escaping ()->()) {
        results = results.sorted(by: {
            if sort == .desc {
                return $0.provider.companyName > $1.provider.companyName
            } else {
                return $0.provider.companyName < $1.provider.companyName
            }
        })
        DispatchQueue.main.async {
            completion()
        }
    }
}
