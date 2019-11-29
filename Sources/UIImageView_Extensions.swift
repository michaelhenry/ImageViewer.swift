import UIKit

extension UIImageView {
    
    // Data holder tap recognizer
    private class TapWithDataRecognizer:UITapGestureRecognizer {
        unowned var viewController:UIViewController!
        var imageDatasource:ImageDataSource?
        var initialIndex:Int = 0
        var options:[ImageViewerOption] = []
    }
    
    public func setupImageViewer(
        with vc:UIViewController, options:[ImageViewerOption] = []) {
         setup(with: vc, datasource: nil, options: options)
    }
    
    public func setupImageViewer(
        with vc:UIViewController,
        url:URL, initialIndex:Int = 0,
        placeholder: UIImage? = nil,
        options:[ImageViewerOption] = []) {
        
        let datasource = SimpleImageDatasource(
            imageItems: [url].compactMap {
                ImageItem.url($0, placeholder: placeholder ?? image)
        })
        setup(
            with: vc,
            datasource: datasource,
            initialIndex: initialIndex,
            options: options)
    }
    
    public func setupImageViewer(
        with vc:UIViewController,
        images:[UIImage], initialIndex:Int = 0,
        options:[ImageViewerOption] = []) {
        
        let datasource = SimpleImageDatasource(
            imageItems: images.compactMap {
                ImageItem.image($0)
        })
        setup(
            with: vc,
            datasource: datasource,
            initialIndex: initialIndex,
            options: options)
    }
    
    public func setupImageViewer(
        with vc:UIViewController,
        urls:[URL], initialIndex:Int = 0,
        options:[ImageViewerOption] = [],
        placeholder: UIImage? = nil) {
        
        let datasource = SimpleImageDatasource(
            imageItems: urls.compactMap {
                ImageItem.url($0, placeholder: placeholder)
        })
        setup(
            with: vc,
            datasource: datasource,
            initialIndex: initialIndex,
            options: options)
    }
    
    public func setupImageViewer(with vc:UIViewController, datasource:ImageDataSource, initialIndex:Int = 0, options:[ImageViewerOption] = []) {
        setup(with: vc, datasource: datasource, initialIndex: initialIndex, options: options)
    }
    
    private func setup(
        with vc:UIViewController,
        datasource:ImageDataSource?,
        initialIndex:Int = 0,
        options:[ImageViewerOption] = []) {
        
        gestureRecognizers?.forEach {
            if let _ = $0 as? UITapGestureRecognizer {
                return
            }
        }
        
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        
        let _tapRecognizer = TapWithDataRecognizer(
            target: self, action: #selector(showImageViewer(_:)))
        _tapRecognizer.numberOfTouchesRequired = 1
        _tapRecognizer.numberOfTapsRequired = 1
        
        // Pass the Data
        _tapRecognizer.viewController = vc
        _tapRecognizer.imageDatasource = datasource
        _tapRecognizer.initialIndex = initialIndex
        _tapRecognizer.options = options
        addGestureRecognizer(_tapRecognizer)
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
        sender.viewController.present(imageCarousel, animated: false, completion: nil)
    }
}
