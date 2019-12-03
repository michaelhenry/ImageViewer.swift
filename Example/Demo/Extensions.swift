//
//  UIImageView_Extensions.swift
//  Demo
//
//  Created by Michael Henry Pantaleon on 2019/12/03.
//  Copyright © 2019 Michael Henry Pantaleon. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func scale(by scale: CGFloat) -> UIImage? {
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return resize(targetSize: scaledSize)
    }
}

extension CGSize {
    static let thumbnail:CGSize = CGSize(width: 50, height:50)
}
