import UIKit

enum ExampleType:CaseIterable, CustomStringConvertible {
    
    case basic
    case withURL
    case withUIImages
    case withURLs
    
    var description: String {
        switch self {
            case .basic:
                return "Basic"
            case .withURL:
                return "With URL"
            case .withUIImages:
                return "With [UIImage]"
            case .withURLs:
                return "With [URL]"
        }
    }
    
    var viewController:UIViewController {
        switch self {
            case .basic:
                return BasicViewController()
            case .withURL:
                return WithURLViewController()
            case .withUIImages:
                return WithImagesViewController()
            case .withURLs:
                return WithURLsViewController()
        }
    }
}

class ExampleListViewController:UITableViewController {
    
    var items:[ExampleType] = ExampleType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ImageViewer.swift"
    }
    
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
    
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        let vc = items[indexPath.row].viewController
        
        switch indexPath.row {
            case 0:
                present(vc, animated: true, completion: nil)
            default:
                navigationController?.pushViewController(
                    vc, animated: true)
        }
    }
}
