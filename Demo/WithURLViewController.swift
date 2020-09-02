import UIKit
import ImageViewer_swift
import SDWebImage

class WithURLViewController:UIViewController {
    
    lazy var imageView:UIImageView = {
        let iv = UIImageView()
        
        // Set an image with low resolution.
        iv.image = Data.images[0].resize(targetSize: .thumbnail)
        
        // Setup Image Viewer With URL
        iv.setupImageViewer(url: Data.imageUrls[0])
        return iv
    }()
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for debugging purposes, just clear the download images
        SDImageCache.shared.clear(with: .all, completion: nil)
    }
}
