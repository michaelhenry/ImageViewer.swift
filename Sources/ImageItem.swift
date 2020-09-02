import UIKit

public enum ImageItem {
    case image(UIImage?)
    #if canImport(SDWebImage)
    case url(URL, placeholder: UIImage?)
    #endif
}
