//
//  BasicViewController.swift
//  Demo
//
//  Created by Michael Henry Pantaleon on 2019/12/03.
//  Copyright © 2019 Michael Henry Pantaleon. All rights reserved.
//

import UIKit
import MHFacebookImageViewer

class BasicViewController:UIViewController {
    
    lazy var imageView:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "cat1")?.resize(targetSize: .thumbnail)
        iv.setupImageViewer()
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

    }
}
