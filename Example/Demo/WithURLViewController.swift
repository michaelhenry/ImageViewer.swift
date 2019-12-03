//
//  WithURLViewController.swift
//  Demo
//
//  Created by Michael Henry Pantaleon on 2019/12/03.
//  Copyright © 2019 Michael Henry Pantaleon. All rights reserved.
//

import UIKit
import MHFacebookImageViewer
import SDWebImage

class WithURLViewController:UIViewController {
    
    lazy var imageView:UIImageView = {
        let iv = UIImageView()
        
        // Set an image with low resolution.
        iv.image = UIImage(named: "cat1")?.resize(targetSize: .thumbnail)
        
        // Setup with URL
        iv.setupImageViewer(url: URL(string: "https://raw.githubusercontent.com/michaelhenry/MHFacebookImageViewer/master/Example/Demo/Assets.xcassets/cat1.imageset/cat1.jpg")!)
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
   
        SDImageCache.shared.clear(with: .all, completion: nil)
    }
}
