import UIKit

struct Data {
    
    static let imageNames:[String] = [
        "cat1",
        "cat2",
        "cat3",
        "cat4",
        "cat5",
        "cat1",
        "cat2",
        "cat3",
        "cat4",
        "cat5",
        "cat1",
        "cat2",
        "cat3",
        "cat4",
        "cat5",
        "cat1",
        "cat2",
        "cat3",
        "cat4",
        "cat5",
    ]
    
    static let images:[UIImage] = Self.imageNames.compactMap { UIImage(named: $0)! }
    
    static let imageUrls:[URL] = Self.imageNames.compactMap {
        URL(string: "https://raw.githubusercontent.com/michaelhenry/MHFacebookImageViewer/master/Example/Demo/Assets.xcassets/\($0).imageset/\($0).jpg")! }
}
