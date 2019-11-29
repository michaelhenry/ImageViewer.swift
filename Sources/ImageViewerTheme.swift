import UIKit

public enum ImageViewerTheme {
    case light
    case dark
    
    var color:UIColor {
        switch self {
            case .light:
                return .white
            case .dark:
                return .black
        }
    }
    
    var tintColor:UIColor {
        switch self {
            case .light:
                return .black
            case .dark:
                return .white
        }
    }
}
