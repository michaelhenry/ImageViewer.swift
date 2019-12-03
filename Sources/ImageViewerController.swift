import UIKit
import SDWebImage

protocol ImageViewerControllerDelegate:class {
    func imageViewerDidClose(_ imageViewer: ImageViewerController)
}

class ImageViewerController:UIViewController, UIGestureRecognizerDelegate {
    
    var index:Int = 0
    weak var delegate:ImageViewerControllerDelegate?
    var imageItem:ImageItem!
    var animateOnDidAppear:Bool = false
    var sourceView:UIImageView?
    
    var backgroundView:UIView? {
        guard let _parent = parent as? ImageCarouselViewController
            else { return nil}
        return _parent.backgroundView
    }
    
    var navBar:UINavigationBar? {
        guard let _parent = parent as? ImageCarouselViewController
            else { return nil}
        return _parent.navBar
    }
    
    private var top:NSLayoutConstraint!
    private var leading:NSLayoutConstraint!
    private var trailing:NSLayoutConstraint!
    private var bottom:NSLayoutConstraint!
    
    private var imageView:UIImageView!
    private var scrollView:UIScrollView!
   
    private var lastLocation:CGPoint = .zero

    init(sourceView:UIImageView? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.sourceView = sourceView
     
        modalPresentationStyle = .overFullScreen
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        
        view.backgroundColor = .clear
        self.view = view
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
      
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(scrollView)
        scrollView.bindFrameToSuperview()
        scrollView.backgroundColor = .clear
        
        imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .gray
        scrollView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        top = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        leading = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        trailing = scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        bottom = scrollView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        
        top.isActive = true
        leading.isActive = true
        trailing.isActive = true
        bottom.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch imageItem {
        case .image(let img):
            imageView.image = img
            imageView.layoutIfNeeded()
        case .url(let url, let placeholder):
            imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [], progress: nil) {[weak self] (img, err, type, url) in
                self?.imageView.layoutIfNeeded()
            }
        default:
            break
        }
        
        addGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard animateOnDidAppear == true,
            let sourceFrame = sourceView?.frameRelativeToWindow()
            else {
                // No animation
                return
        }
                
        animateOnDidAppear = false
    
        let dummyImageView:UIImageView = UIImageView(frame: sourceFrame)
        dummyImageView.clipsToBounds = true
        dummyImageView.contentMode = .scaleAspectFill
        dummyImageView.alpha = 1.0
        dummyImageView.image = imageView.image
        view.addSubview(dummyImageView)
        view.sendSubviewToBack(dummyImageView)
        
        sourceView?.alpha = 1.0
        imageView.alpha = 0.0
        backgroundView?.alpha = 0.0
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            guard let _self = self else { return }
            UIView.animate(withDuration: 0.237, animations: {
                dummyImageView.contentMode = .scaleAspectFit
                dummyImageView.frame = _self.view.frame
                _self.backgroundView?.alpha = 1.0
                _self.sourceView?.alpha = 0.0
            }) { _ in
                _self.imageView.alpha = 1.0
                dummyImageView.removeFromSuperview()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    func addGestureRecognizers() {
        
        let panGesture = UIPanGestureRecognizer(
            target: self, action: #selector(didPan(_:)))
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)

        let pinchRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didPinch(_:)))
        pinchRecognizer.numberOfTapsRequired = 1
        pinchRecognizer.numberOfTouchesRequired = 2
        scrollView.addGestureRecognizer(pinchRecognizer)
        
        let singleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(didSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        scrollView.maximumZoomScale = 4.0
        
        singleTapGesture.require(toFail: doubleTapRecognizer)
    }
    
    func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    @objc
    func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if scrollView.minimumZoomScale != scrollView.zoomScale { return }
        let container:UIView! = imageView
        if gestureRecognizer.state == .began {
            lastLocation = container.center
        }
        
        if gestureRecognizer.state != .cancelled {
            let translation: CGPoint = gestureRecognizer
                .translation(in: view)
            container.center = CGPoint(
                x: container.center.x,
                y: lastLocation.y + translation.y)
        }

        let diffY = view.center.y - container.center.y
        backgroundView?.alpha = 1.0 - abs(diffY/view.center.y)
        if gestureRecognizer.state == .ended {
            if abs(diffY) > 60 {
                let dummyImageView:UIImageView = UIImageView(frame: container.frame)
                dummyImageView.image = imageView.image
                dummyImageView.clipsToBounds = false
                dummyImageView.contentMode = .scaleAspectFill
                view.addSubview(dummyImageView)
                imageView.isHidden = true
                
                let exitFrame:CGRect = { () -> CGRect in
                    guard let _sourceFrame = self.sourceView?.frameRelativeToWindow()
                        else {
                            var imageViewFrame = self.imageView.frame
                            if diffY > 0 {
                                imageViewFrame.origin.y = -imageViewFrame.size.height
                            } else {
                                imageViewFrame.origin.y = view.frame.size.height
                            }
                           return imageViewFrame
                    }
                    return _sourceFrame
                }()
                
                UIView.animate(withDuration: 0.237, animations: {
                    dummyImageView.frame = exitFrame
                    dummyImageView.clipsToBounds = true
                    self.backgroundView?.alpha = 0.0
                    self.navBar?.alpha = 0.0
                }) { _ in
                    self.dismiss(animated: false) {
                        dummyImageView.removeFromSuperview()
                        self.delegate?.imageViewerDidClose(self)
                    }
                }
            } else {
                UIView.animate(
                    withDuration: 0.237,
                    animations: {
                        container.center = self.view.center
                        self.backgroundView?.alpha = 1.0
                })
            }
        }
    }
    
    @objc
    func didPinch(_ recognizer: UITapGestureRecognizer) {
        var newZoomScale = scrollView.zoomScale / 1.5
        newZoomScale = max(newZoomScale, scrollView.minimumZoomScale)
        scrollView.setZoomScale(newZoomScale, animated: true)
    }
    
    @objc
    func didSingleTap(_ recognizer: UITapGestureRecognizer) {
        
        let currentNavAlpha = self.navBar?.alpha ?? 0.0
        UIView.animate(withDuration: 0.235) {
            self.navBar?.alpha = currentNavAlpha > 0.5 ? 0.0 : 1.0
        }
    }
    
    @objc
    func didDoubleTap(_ recognizer:UITapGestureRecognizer) {
        let pointInView = recognizer.location(in: imageView)
        zoomInOrOut(at: pointInView)
    }
    
    func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        top.constant = yOffset
        bottom.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        leading.constant = xOffset
        trailing.constant = xOffset
        view.layoutIfNeeded()
    }
    
    func zoomInOrOut(at point:CGPoint) {
        let newZoomScale = scrollView.zoomScale == scrollView.minimumZoomScale
            ? scrollView.maximumZoomScale : scrollView.minimumZoomScale
        let size = scrollView.bounds.size
        let w = size.width / newZoomScale
        let h = size.height / newZoomScale
        let x = point.x - (w * 0.5)
        let y = point.y - (h * 0.5)
        let rect = CGRect(x: x, y: y, width: w, height: h)
        scrollView.zoom(to: rect, animated: true)
    }

    func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: scrollView)
            return abs(velocity.y) > abs(velocity.x)
        }
        return false
    }
}

extension ImageViewerController:UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
}

extension ImageViewerController {
    
    static func create(
        index: Int,
        imageItem:ImageItem,
        sourceView:UIImageView?,
        delegate:ImageViewerControllerDelegate) -> ImageViewerController {
        
        let newVC = ImageViewerController()
        newVC.index = index
        newVC.imageItem = imageItem
        newVC.sourceView = sourceView
        newVC.delegate = delegate
        return newVC
    }
}
