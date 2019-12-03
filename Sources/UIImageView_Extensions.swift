import UIKit

extension UIImageView {
    
    // Data holder tap recognizer
    private class TapWithDataRecognizer:UITapGestureRecognizer {
        var imageDatasource:ImageDataSource?
        var initialIndex:Int = 0
        var options:[ImageViewerOption] = []
    }
    
    private var vc:UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    public func setupImageViewer(
        options:[ImageViewerOption] = []) {
        setup(datasource: nil, options: options)
    }
    
    public func setupImageViewer(
        url:URL,
        initialIndex:Int = 0,
        placeholder: UIImage? = nil,
        options:[ImageViewerOption] = []) {
        
        let datasource = SimpleImageDatasource(
            imageItems: [url].compactMap {
                ImageItem.url($0, placeholder: placeholder ?? image)
        })
        setup(
            datasource: datasource,
            initialIndex: initialIndex,
            options: options)
    }
    
    public func setupImageViewer(
        images:[UIImage],
        initialIndex:Int = 0,
        options:[ImageViewerOption] = []) {
        
        let datasource = SimpleImageDatasource(
            imageItems: images.compactMap {
                ImageItem.image($0)
        })
        setup(
            datasource: datasource,
            initialIndex: initialIndex,
            options: options)
    }
    
    public func setupImageViewer(
        urls:[URL],
        initialIndex:Int = 0,
        options:[ImageViewerOption] = [],
        placeholder: UIImage? = nil) {
        
        let datasource = SimpleImageDatasource(
            imageItems: urls.compactMap {
                ImageItem.url($0, placeholder: placeholder ?? image)
        })
        setup(
            datasource: datasource,
            initialIndex: initialIndex,
            options: options)
    }
    
    public func setupImageViewer(
        datasource:ImageDataSource,
        initialIndex:Int = 0,
        options:[ImageViewerOption] = []) {
        
        setup(
            datasource: datasource,
            initialIndex: initialIndex,
            options: options)
    }
    
    private func setup(
        datasource:ImageDataSource?,
        initialIndex:Int = 0,
        options:[ImageViewerOption] = []) {
        
        var _tapRecognizer:TapWithDataRecognizer?
        gestureRecognizers?.forEach {
            if let _tr = $0 as? TapWithDataRecognizer {
                // if found, just use existing
                _tapRecognizer = _tr
            }
        }
        
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        if _tapRecognizer == nil {
            _tapRecognizer = TapWithDataRecognizer(
                target: self, action: #selector(showImageViewer(_:)))
            _tapRecognizer!.numberOfTouchesRequired = 1
            _tapRecognizer!.numberOfTapsRequired = 1
        }
        // Pass the Data
        _tapRecognizer!.imageDatasource = datasource
        _tapRecognizer!.initialIndex = initialIndex
        _tapRecognizer!.options = options
        addGestureRecognizer(_tapRecognizer!)
    }
    
    @objc
    private func showImageViewer(_ sender:TapWithDataRecognizer) {
        guard let sourceView = sender.view as? UIImageView else { return }
        let imageCarousel = ImageCarouselViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
        imageCarousel.sourceView = sourceView
        imageCarousel.imageDatasource = sender.imageDatasource
        imageCarousel.initialIndex = sender.initialIndex
        imageCarousel.imageDatasource = sender.imageDatasource
        imageCarousel.options = sender.options
        imageCarousel.modalPresentationStyle = .overFullScreen
        imageCarousel.modalPresentationCapturesStatusBarAppearance = true
        vc?.present(imageCarousel, animated: false, completion: nil)
    }
}
