//
//  ExampleListViewController.swift
//  Demo
//
//  Created by Michael Henry Pantaleon on 2019/12/03.
//  Copyright © 2019 Michael Henry Pantaleon. All rights reserved.
//

import UIKit

enum ExampleType:CaseIterable, CustomStringConvertible {
    
    case basic
    case withURL
    
    var description: String {
        switch self {
            case .basic:
                return "Basic"
            case .withURL:
                return "With URL"
        }
    }
    
    var viewController:UIViewController {
        switch self {
            case .basic:
                return BasicViewController()
            case .withURL:
                return WithURLViewController()
        }
    }
}

class ExampleListViewController:UITableViewController {
    
    var items:[ExampleType] = ExampleType.allCases
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        return items.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemReuseId = "item_reuse_identifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: itemReuseId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: itemReuseId)
        }
        cell?.textLabel?.text = items[indexPath.row].description
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(
            items[indexPath.row].viewController, animated: true)
    }
}
